#!/bin/bash

# Скрипт для исправления проблем с кластером

echo "Проверка и исправление кластера..."

# Проверяем статус Minikube
echo "Проверка Minikube..."
minikube status

# Если кластер не запущен, запускаем
if ! minikube status | grep -q "Running"; then
    echo "Запуск Minikube..."
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS - проверяем архитектуру
        if [[ $(uname -m) == "arm64" ]]; then
            # Apple Silicon - пробуем разные драйверы
            echo "Попытка запуска с драйвером qemu..."
            if minikube start --driver=qemu --memory=4096 --cpus=2 --disk-size=20g --kubernetes-version=v1.28.0 2>/dev/null; then
                echo "Успешно запущен с qemu"
            else
                echo "qemu не работает, пробуем docker..."
                if minikube start --driver=docker --memory=4096 --cpus=2 --disk-size=20g --kubernetes-version=v1.28.0 2>/dev/null; then
                    echo "Успешно запущен с docker"
                else
                    echo "docker не работает, пробуем vmware..."
                    if minikube start --driver=vmware --memory=4096 --cpus=2 --disk-size=20g --kubernetes-version=v1.28.0 2>/dev/null; then
                        echo "Успешно запущен с vmware"
                    else
                        echo "vmware не работает, пробуем virtualbox..."
                        minikube start --driver=virtualbox --memory=4096 --cpus=2 --disk-size=20g --kubernetes-version=v1.28.0
                    fi
                fi
            fi
        else
            # Intel Mac - используем hyperkit
            minikube start --driver=hyperkit --memory=4096 --cpus=2 --disk-size=20g --kubernetes-version=v1.28.0
        fi
    else
        # Linux - используем docker
        minikube start --driver=docker --memory=4096 --cpus=2 --disk-size=20g --kubernetes-version=v1.28.0
    fi
    
    # Проверяем успешность запуска
    if [ $? -ne 0 ]; then
        echo "Ошибка: Не удалось запустить Minikube"
        exit 1
    fi
fi

# Ждем готовности
echo "Ожидание готовности кластера..."
kubectl wait --for=condition=Ready nodes --all --timeout=300s

# Проверяем успешность ожидания
if [ $? -ne 0 ]; then
    echo "Ошибка: Кластер не готов к работе"
    exit 1
fi

# Проверяем подключение
echo "Проверка подключения к кластеру..."
kubectl get nodes

# Включаем аддоны если нужно
echo "Проверка аддонов..."
minikube addons enable storage-provisioner
minikube addons enable default-storageclass

echo "Кластер готов к работе"
