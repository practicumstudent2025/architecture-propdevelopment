#!/bin/bash

# Развертывание сервисов для Task 5 - Управление трафиком

echo "=== Развертывание сервисов PropDevelopment ==="

# Создаем namespace для Task 5
echo "Создание namespace..."
kubectl create namespace task5

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
kubectl wait --for=condition=Ready pods --all --namespace=task5 --timeout=60s

# Проверяем наличие wget в подах
echo "Проверка wget в подах..."
for pod in front-end-app back-end-api-app admin-front-end-app admin-back-end-api-app; do
    echo "Проверка wget в $pod..."
    kubectl exec $pod --namespace=task5 -- which wget || echo "wget не найден в $pod"
done

echo "Сервисы развернуты успешно!"
echo ""
echo "Созданные сервисы:"
kubectl get pods --namespace=task5
echo ""
echo "Созданные сервисы (services):"
kubectl get services --namespace=task5
