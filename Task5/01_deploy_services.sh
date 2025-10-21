#!/bin/bash

# Развертывание сервисов для Task 5 - Управление трафиком

echo "=== Развертывание сервисов PropDevelopment ==="

# Создаем namespace для Task 5
echo "Создание namespace..."
kubectl create namespace task5

# Создаем ServiceAccount для namespace
echo "Создание ServiceAccount..."
kubectl create serviceaccount default --namespace=task5

# Развертываем 4 сервиса с метками через Deployment
echo "Развертывание front-end сервиса..."
kubectl create deployment front-end-app --image=nginx --labels role=front-end --namespace=task5
kubectl expose deployment front-end-app --port 80 --namespace=task5

echo "Развертывание back-end-api сервиса..."
kubectl create deployment back-end-api-app --image=nginx --labels role=back-end-api --namespace=task5
kubectl expose deployment back-end-api-app --port 80 --namespace=task5

echo "Развертывание admin-front-end сервиса..."
kubectl create deployment admin-front-end-app --image=nginx --labels role=admin-front-end --namespace=task5
kubectl expose deployment admin-front-end-app --port 80 --namespace=task5

echo "Развертывание admin-back-end-api сервиса..."
kubectl create deployment admin-back-end-api-app --image=nginx --labels role=admin-back-end-api --namespace=task5
kubectl expose deployment admin-back-end-api-app --port 80 --namespace=task5

# Ждем готовности подов
echo "Ожидание готовности подов..."
kubectl wait --for=condition=Ready pods --all --namespace=task5 --timeout=60s

# Проверяем наличие curl в подах
echo "Проверка curl в подах..."
for pod in front-end-app back-end-api-app admin-front-end-app admin-back-end-api-app; do
    echo "Проверка curl в $pod..."
    kubectl exec $pod --namespace=task5 -- which curl || echo "curl не найден в $pod"
done

echo "Сервисы развернуты успешно!"
echo ""
echo "Созданные сервисы:"
kubectl get pods --namespace=task5
echo ""
echo "Созданные сервисы (services):"
kubectl get services --namespace=task5
