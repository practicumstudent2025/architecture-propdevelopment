#!/bin/bash

# Настройка Minikube с поддержкой сетевых политик для Task 5

echo "=== Настройка Minikube для Task 5 ==="

# Останавливаем и удаляем существующий кластер
echo "Остановка существующего кластера..."
minikube stop >/dev/null 2>&1 || true
minikube delete >/dev/null 2>&1 || true

# Запускаем новый кластер с поддержкой сетевых политик
echo "Запуск Minikube с поддержкой сетевых политик..."
minikube start --driver=docker --memory=4096 --cpus=2 --disk-size=20g --kubernetes-version=v1.28.0 --cni=calico >/dev/null 2>&1

# Проверяем успешность запуска
if [ $? -ne 0 ]; then
    echo "Ошибка: Не удалось запустить Minikube с Calico"
    echo "Попробуем с flannel..."
    minikube start --driver=docker --memory=4096 --cpus=2 --disk-size=20g --kubernetes-version=v1.28.0 --cni=flannel >/dev/null 2>&1
    
    if [ $? -ne 0 ]; then
        echo "Ошибка: Не удалось запустить Minikube с flannel"
        exit 1
    fi
fi

# Ждем готовности кластера
echo "Ожидание готовности кластера..."
kubectl wait --for=condition=Ready nodes --all --timeout=300s >/dev/null 2>&1

# Проверяем успешность ожидания
if [ $? -ne 0 ]; then
    echo "Ошибка: Кластер не готов к работе"
    exit 1
fi

# Включаем необходимые аддоны
echo "Включение аддонов..."
minikube addons enable storage-provisioner >/dev/null 2>&1
minikube addons enable default-storageclass >/dev/null 2>&1

echo "Minikube настроен с поддержкой сетевых политик"
echo "CNI плагин: $(kubectl get pods -n kube-system | grep -E "(calico|flannel)" | head -1 | awk '{print $1}')"
