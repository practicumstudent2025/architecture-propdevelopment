#!/bin/bash

# Настройка Minikube для PropDevelopment

echo "Настройка Minikube..."

# Проверяем Minikube
if ! command -v minikube &> /dev/null; then
    echo "Ошибка: Minikube не установлен"
    exit 1
fi

# Останавливаем и удаляем существующий кластер
minikube stop 2>/dev/null || true
minikube delete 2>/dev/null || true

# Запускаем новый кластер с Docker драйвером
echo "Запуск Minikube..."
minikube start --driver=docker --memory=4096 --cpus=2 --disk-size=20g --kubernetes-version=v1.28.0 >/dev/null 2>&1

# Проверяем успешность запуска
if [ $? -ne 0 ]; then
    echo "Ошибка: Не удалось запустить Minikube"
    exit 1
fi

# Ждем готовности кластера
echo "Ожидание готовности кластера..."
kubectl wait --for=condition=Ready nodes --all --timeout=300s >/dev/null 2>&1

# Проверяем успешность ожидания
if [ $? -ne 0 ]; then
    echo "Ошибка: Кластер не готов к работе"
    exit 1
fi

# Включаем только необходимые аддоны
minikube addons enable storage-provisioner >/dev/null 2>&1
minikube addons enable default-storageclass >/dev/null 2>&1

# Создаем namespace
kubectl create namespace sales >/dev/null 2>&1
kubectl create namespace tenant-services >/dev/null 2>&1
kubectl create namespace finance >/dev/null 2>&1
kubectl create namespace data >/dev/null 2>&1
kubectl create namespace smart-home >/dev/null 2>&1
kubectl create namespace monitoring >/dev/null 2>&1
kubectl create namespace security >/dev/null 2>&1

# Добавляем метки
kubectl label namespace sales domain=sales data-classification=confidential >/dev/null 2>&1
kubectl label namespace tenant-services domain=tenant data-classification=confidential >/dev/null 2>&1
kubectl label namespace finance domain=finance data-classification=secret >/dev/null 2>&1
kubectl label namespace data domain=data data-classification=confidential >/dev/null 2>&1
kubectl label namespace smart-home domain=smart-home data-classification=secret >/dev/null 2>&1
kubectl label namespace monitoring domain=monitoring data-classification=internal >/dev/null 2>&1
kubectl label namespace security domain=security data-classification=secret >/dev/null 2>&1

# Создаем NetworkPolicy для изоляции
for ns in sales tenant-services finance data smart-home security; do
  kubectl apply -f - <<EOF >/dev/null 2>&1
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: default-deny-all
  namespace: $ns
spec:
  podSelector: {}
  policyTypes:
  - Ingress
  - Egress
EOF
done

echo "Minikube настроен"
