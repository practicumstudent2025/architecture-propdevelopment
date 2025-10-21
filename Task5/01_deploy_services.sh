#!/bin/bash

# Развертывание сервисов для Task 5 - Управление трафиком

echo "=== Развертывание сервисов PropDevelopment ==="

# Создаем namespace для Task 5
echo "Создание namespace..."
kubectl create namespace task5 >/dev/null 2>&1

# Развертываем 4 сервиса с метками
echo "Развертывание front-end сервиса..."
kubectl run front-end-app --image=nginx --labels role=front-end --expose --port 80 --namespace=task5

echo "Развертывание back-end-api сервиса..."
kubectl run back-end-api-app --image=nginx --labels role=back-end-api --expose --port 80 --namespace=task5

echo "Развертывание admin-front-end сервиса..."
kubectl run admin-front-end-app --image=nginx --labels role=admin-front-end --expose --port 80 --namespace=task5

echo "Развертывание admin-back-end-api сервиса..."
kubectl run admin-back-end-api-app --image=nginx --labels role=admin-back-end-api --expose --port 80 --namespace=task5

# Ждем готовности подов
echo "Ожидание готовности подов..."
kubectl wait --for=condition=Ready pods --all --namespace=task5 --timeout=60s >/dev/null 2>&1

# Устанавливаем wget в поды для тестирования
echo "Установка wget в поды..."
kubectl exec front-end-app --namespace=task5 -- apt-get update >/dev/null 2>&1
kubectl exec front-end-app --namespace=task5 -- apt-get install -y wget >/dev/null 2>&1
kubectl exec back-end-api-app --namespace=task5 -- apt-get update >/dev/null 2>&1
kubectl exec back-end-api-app --namespace=task5 -- apt-get install -y wget >/dev/null 2>&1
kubectl exec admin-front-end-app --namespace=task5 -- apt-get update >/dev/null 2>&1
kubectl exec admin-front-end-app --namespace=task5 -- apt-get install -y wget >/dev/null 2>&1
kubectl exec admin-back-end-api-app --namespace=task5 -- apt-get update >/dev/null 2>&1
kubectl exec admin-back-end-api-app --namespace=task5 -- apt-get install -y wget >/dev/null 2>&1

echo "Сервисы развернуты успешно!"
echo ""
echo "Созданные сервисы:"
kubectl get pods --namespace=task5
echo ""
echo "Созданные сервисы (services):"
kubectl get services --namespace=task5
