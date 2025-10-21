#!/bin/bash

# Скрипт для исправления проблем с кластером

echo "Проверка и исправление кластера..."

# Проверяем статус Minikube
echo "Проверка Minikube..."
minikube status

# Если кластер не запущен, запускаем
if ! minikube status | grep -q "Running"; then
    echo "Запуск Minikube..."
    minikube start --driver=docker --memory=4096 --cpus=2 --disk-size=20g --kubernetes-version=v1.28.0
fi

# Ждем готовности
echo "Ожидание готовности кластера..."
kubectl wait --for=condition=Ready nodes --all --timeout=300s

# Проверяем подключение
echo "Проверка подключения к кластеру..."
kubectl get nodes

# Включаем аддоны если нужно
echo "Проверка аддонов..."
minikube addons enable storage-provisioner
minikube addons enable default-storageclass

echo "Кластер готов к работе"
