#!/bin/bash

# Скрипт для поднятия пустого Minikube для PropDevelopment
# Основан на анализе заданий 1-3

echo "=== Настройка Minikube для PropDevelopment ==="

# Проверяем, что Minikube установлен
if ! command -v minikube &> /dev/null; then
    echo "❌ Minikube не установлен. Установите Minikube сначала."
    exit 1
fi

# Останавливаем существующий кластер, если он запущен
echo "🛑 Останавливаем существующий кластер..."
minikube stop 2>/dev/null || true

# Удаляем существующий кластер
echo "🗑️ Удаляем существующий кластер..."
minikube delete 2>/dev/null || true

# Запускаем новый кластер с настройками для PropDevelopment
echo "🚀 Запускаем новый кластер Minikube..."
minikube start \
    --driver=docker \
    --memory=4096 \
    --cpus=2 \
    --disk-size=20g \
    --kubernetes-version=v1.28.0

# Проверяем статус кластера
echo "✅ Проверяем статус кластера..."
minikube status

# Включаем необходимые аддоны для PropDevelopment
echo "🔧 Включаем необходимые аддоны..."

# Включаем dashboard для мониторинга
minikube addons enable dashboard

# Включаем metrics-server для мониторинга ресурсов
minikube addons enable metrics-server

# Включаем ingress для внешнего доступа
minikube addons enable ingress

# Включаем storage-provisioner для PersistentVolumes
minikube addons enable storage-provisioner

# Включаем default-storageclass для автоматического создания StorageClass
minikube addons enable default-storageclass

echo "📋 Создаем namespace для PropDevelopment..."

# Создаем namespace для доменов PropDevelopment
kubectl create namespace sales
kubectl create namespace tenant-services  
kubectl create namespace finance
kubectl create namespace data
kubectl create namespace smart-home
kubectl create namespace monitoring
kubectl create namespace security

# Добавляем метки к namespace для организации
kubectl label namespace sales domain=sales
kubectl label namespace tenant-services domain=tenant
kubectl label namespace finance domain=finance
kubectl label namespace data domain=data
kubectl label namespace smart-home domain=smart-home
kubectl label namespace monitoring domain=monitoring
kubectl label namespace security domain=security

echo "🏷️ Создаем метки для организации ресурсов..."

# Создаем метки для классификации данных (на основе задания 1)
kubectl label namespace sales data-classification=confidential
kubectl label namespace tenant-services data-classification=confidential
kubectl label namespace finance data-classification=secret
kubectl label namespace data data-classification=confidential
kubectl label namespace smart-home data-classification=secret
kubectl label namespace security data-classification=secret

echo "🔐 Настраиваем базовую безопасность..."

# Создаем NetworkPolicy для изоляции namespace
cat <<EOF | kubectl apply -f -
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: default-deny-all
  namespace: sales
spec:
  podSelector: {}
  policyTypes:
  - Ingress
  - Egress
EOF

# Применяем NetworkPolicy для всех namespace
for ns in tenant-services finance data smart-home security; do
  kubectl apply -f - <<EOF
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

echo "📊 Проверяем созданные ресурсы..."
kubectl get namespaces
kubectl get networkpolicies --all-namespaces

echo "✅ Minikube настроен для PropDevelopment!"
echo "🌐 Для доступа к dashboard выполните: minikube dashboard"
echo "📝 Namespace созданы для всех доменов PropDevelopment"
echo "🔒 Базовая безопасность настроена с NetworkPolicy"
