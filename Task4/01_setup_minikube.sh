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

# Запускаем новый кластер
minikube start --driver=docker --memory=4096 --cpus=2 --disk-size=20g --kubernetes-version=v1.28.0

# Ждем готовности кластера
echo "Ожидание готовности кластера..."
kubectl wait --for=condition=Ready nodes --all --timeout=300s

# Включаем только необходимые аддоны
minikube addons enable storage-provisioner
minikube addons enable default-storageclass

# Создаем namespace
kubectl create namespace sales
kubectl create namespace tenant-services  
kubectl create namespace finance
kubectl create namespace data
kubectl create namespace smart-home
kubectl create namespace monitoring
kubectl create namespace security

# Добавляем метки
kubectl label namespace sales domain=sales data-classification=confidential
kubectl label namespace tenant-services domain=tenant data-classification=confidential
kubectl label namespace finance domain=finance data-classification=secret
kubectl label namespace data domain=data data-classification=confidential
kubectl label namespace smart-home domain=smart-home data-classification=secret
kubectl label namespace monitoring domain=monitoring data-classification=internal
kubectl label namespace security domain=security data-classification=secret

# Создаем NetworkPolicy для изоляции
for ns in sales tenant-services finance data smart-home security; do
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

echo "Minikube настроен"
