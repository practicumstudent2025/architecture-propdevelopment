#!/bin/bash

# ============================================
# Развертывание четырёх сервисов Nginx в namespace task5
# с применением сетевых политик Calico
# ============================================

echo "=== Развертывание сервисов ==="

# Очистка окружения (опционально)
echo "Полная очистка Minikube и Docker..."
minikube delete --all --purge >/dev/null 2>&1
docker system prune -af >/dev/null 2>&1 || true
echo "Очистка завершена"

# Проверяем, запущен ли кластер
if ! kubectl get nodes >/dev/null 2>&1; then
    echo "Кластер не запущен, запускаем Minikube с docker-драйвером..."
    minikube start --driver=docker --cni=calico \
      --kubernetes-version=v1.30.0 \
      --extra-config=controller-manager.cluster-cidr=10.244.0.0/16 \
      --extra-config=kubelet.pod-cidr=10.244.0.0/16

    if [ $? -ne 0 ]; then
        echo "❌ Ошибка: Не удалось запустить Minikube"
        exit 1
    fi
    echo "✅ Minikube запущен успешно"
fi

# Проверяем готовность системных подов
echo "⏳ Ожидание готовности системных подов (kube-system)..."
kubectl wait --for=condition=Ready pods --all -n kube-system --timeout=120s >/dev/null 2>&1 || true

# Проверяем, существует ли namespace task5
if kubectl get namespace task5 >/dev/null 2>&1; then
    echo "Namespace task5 уже существует, удаляем..."
    kubectl delete namespace task5 --force --grace-period=0
    echo "Ждем полного удаления namespace..."
    while kubectl get namespace task5 >/dev/null 2>&1; do
        sleep 2
        echo "Ожидание удаления namespace..."
    done
    echo "Namespace удален успешно"
fi

# Создаем namespace
kubectl create namespace task5
echo "⏳ Ожидание готовности контроллеров Kubernetes..."
kubectl wait --for=condition=Ready pods -n kube-system -l component=kube-controller-manager --timeout=60s >/dev/null 2>&1 || true

# Проверяем наличие ServiceAccount default
echo "Ожидание создания service account..."
for i in {1..10}; do
  if kubectl get serviceaccount default -n task5 >/dev/null 2>&1; then
    echo "✅ ServiceAccount default найден!"
    break
  fi
  echo "⏳ Ожидание... ($i)"
  sleep 3
done

if ! kubectl get serviceaccount default -n task5 >/dev/null 2>&1; then
  echo "⚠️  ServiceAccount default не найден, создаем вручную..."
  kubectl create serviceaccount default -n task5
else
  echo "✅ ServiceAccount default готов к использованию!"
fi

# Применяем deployment и service YAML
echo "Применяем deployment и service YAML..."
kubectl apply -f deploy_services.yaml

# Ожидание готовности подов
echo "Ожидание готовности подов..."
kubectl wait --for=condition=Ready pod -l role=admin-back-end-api --namespace=task5 --timeout=60s
kubectl wait --for=condition=Ready pod -l role=admin-front-end --namespace=task5 --timeout=60s
kubectl wait --for=condition=Ready pod -l role=back-end-api --namespace=task5 --timeout=60s
kubectl wait --for=condition=Ready pod -l role=front-end --namespace=task5 --timeout=60s
echo "✅ Сервисы развернуты успешно!"

# Применяем сетевые политики
echo "Применение сетевых политик..."
kubectl apply -f non-admin-api-allow.yaml
if [ $? -eq 0 ]; then
    echo "✅ Сетевые политики применены успешно"
    echo "Ждем активации политик..."
    sleep 5
else
    echo "❌ Ошибка: Не удалось применить сетевые политики"
    exit 1
fi

# Вывод информации о состоянии
echo ""
echo "Поды:"
kubectl get pods --namespace=task5
echo ""
echo "Сервисы:"
kubectl get services --namespace=task5
echo ""
echo "Сетевые политики:"
kubectl get networkpolicies --namespace=task5

# Проверка сетевых политик
echo ""
echo "=== Проверка сетевых политик ==="
kubectl get networkpolicies --namespace=task5

# Получаем IP адреса сервисов
FRONT_END_IP=$(kubectl get service front-end-app --namespace=task5 -o jsonpath='{.spec.clusterIP}')
BACK_END_API_IP=$(kubectl get service back-end-api-app --namespace=task5 -o jsonpath='{.spec.clusterIP}')
ADMIN_FRONT_END_IP=$(kubectl get service admin-front-end-app --namespace=task5 -o jsonpath='{.spec.clusterIP}')
ADMIN_BACK_END_API_IP=$(kubectl get service admin-back-end-api-app --namespace=task5 -o jsonpath='{.spec.clusterIP}')

echo ""
echo "IP адреса сервисов:"
echo "front-end: $FRONT_END_IP"
echo "back-end-api: $BACK_END_API_IP"
echo "admin-front-end: $ADMIN_FRONT_END_IP"
echo "admin-back-end-api: $ADMIN_BACK_END_API_IP"

# === Тесты сетевых политик ===

test_connection() {
  local TEST_NAME=$1
  local SOURCE_POD=$2
  local TARGET_IP=$3
  local EXPECTED=$4

  echo ""
  echo "$TEST_NAME"
  echo "Ожидалось: $EXPECTED"

  # Используем существующие поды для тестирования
  RESULT=$(kubectl exec $SOURCE_POD -n task5 -- curl -s --max-time 3 http://$TARGET_IP >/dev/null 2>&1 && echo "SUCCESS" || echo "FAILED")

  if [ "$RESULT" = "SUCCESS" ] && [[ "$EXPECTED" == *"работать"* ]]; then
      echo "Результат: Подключение работает ✓"
  elif [ "$RESULT" = "FAILED" ] && [[ "$EXPECTED" == *"заблокировано"* ]]; then
      echo "Результат: Подключение заблокировано ✓"
  else
      echo "Результат: Неверное поведение ✗"
  fi
}

# Получаем имена подов для тестирования
FRONT_END_POD=$(kubectl get pods -n task5 -l role=front-end -o jsonpath='{.items[0].metadata.name}')
ADMIN_FRONT_END_POD=$(kubectl get pods -n task5 -l role=admin-front-end -o jsonpath='{.items[0].metadata.name}')

test_connection "Тест 1: front-end -> back-end-api" "$FRONT_END_POD" "$BACK_END_API_IP" "Подключение должно работать"
test_connection "Тест 2: admin-front-end -> admin-back-end-api" "$ADMIN_FRONT_END_POD" "$ADMIN_BACK_END_API_IP" "Подключение должно работать"
test_connection "Тест 3: front-end -> admin-back-end-api" "$FRONT_END_POD" "$ADMIN_BACK_END_API_IP" "Подключение должно быть заблокировано"
test_connection "Тест 4: admin-front-end -> back-end-api" "$ADMIN_FRONT_END_POD" "$BACK_END_API_IP" "Подключение должно быть заблокировано"

echo ""
echo "=== Проверка сетевых политик завершена ==="
