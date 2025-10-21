#!/bin/bash

# Скрипт для исправления проблем с кластером

echo "Проверка и исправление кластера..."

# Проверяем статус Minikube
echo "Проверка Minikube..."
minikube status >/dev/null 2>&1

# Если кластер не запущен, запускаем
if ! minikube status | grep -q "Running"; then
    echo "Запуск Minikube с Docker драйвером..."
    minikube start --driver=docker --memory=4096 --cpus=2 --disk-size=20g --kubernetes-version=v1.28.0 >/dev/null 2>&1
    
    # Проверяем успешность запуска
    if [ $? -ne 0 ]; then
        echo "Ошибка: Не удалось запустить Minikube"
        exit 1
    fi
fi

# Ждем готовности
echo "Ожидание готовности кластера..."
kubectl wait --for=condition=Ready nodes --all --timeout=300s >/dev/null 2>&1

# Проверяем успешность ожидания
if [ $? -ne 0 ]; then
    echo "Ошибка: Кластер не готов к работе"
    exit 1
fi

# Проверяем подключение
echo "Проверка подключения к кластеру..."
kubectl get nodes >/dev/null 2>&1

# Включаем аддоны если нужно
echo "Проверка аддонов..."
minikube addons enable storage-provisioner >/dev/null 2>&1
minikube addons enable default-storageclass >/dev/null 2>&1

echo "Кластер готов к работе"
