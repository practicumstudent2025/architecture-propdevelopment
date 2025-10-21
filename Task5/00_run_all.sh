#!/bin/bash

# Мастер-скрипт для Task 5 - Управление трафиком в Kubernetes

echo "=== Task 5: Управление трафиком в Kubernetes ==="

# Проверяем, что мы в правильной директории
if [ ! -f "01_deploy_services.sh" ]; then
    echo "Ошибка: Запустите скрипт из директории Task5/"
    exit 1
fi

# Функция для проверки успешности выполнения
check_success() {
    if [ $? -eq 0 ]; then
        echo "OK: $1"
    else
        echo "ОШИБКА: $1"
        exit 1
    fi
}

echo "Проверка предварительных требований..."

# Проверяем kubectl
if ! command -v kubectl &> /dev/null; then
    echo "Ошибка: kubectl не установлен"
    exit 1
fi

# Проверяем подключение к кластеру
if ! kubectl get nodes &> /dev/null; then
    echo "Ошибка: Нет подключения к кластеру Kubernetes"
    echo "Настраиваем Minikube с поддержкой сетевых политик..."
    ./00_setup_minikube.sh
    check_success "Настройка Minikube"
else
    # Проверяем, поддерживает ли кластер сетевые политики
    echo "Проверка поддержки сетевых политик..."
    if ! kubectl get pods -n kube-system | grep -E "(calico|flannel|cilium)" &> /dev/null; then
        echo "Кластер не поддерживает сетевые политики!"
        echo "Настраиваем Minikube с поддержкой сетевых политик..."
        ./00_setup_minikube.sh
        check_success "Настройка Minikube"
    else
        echo "Кластер поддерживает сетевые политики ✅"
    fi
fi

echo "Все требования выполнены"
echo ""

# Этап 1: Развертывание сервисов
echo "Этап 1: Развертывание сервисов"
./01_deploy_services.sh
check_success "Развертывание сервисов"

# Этап 2: Создание сетевых политик
echo "Этап 2: Создание сетевых политик"
./02_create_network_policies.sh
check_success "Создание сетевых политик"

# Этап 3: Тестирование связности
echo "Этап 3: Тестирование связности"
./03_test_connectivity.sh
check_success "Тестирование связности"

echo ""
echo "=== TASK 5 ЗАВЕРШЕН ==="
echo ""
echo "Результаты:"
echo "- Namespace: $(kubectl get namespaces | grep task5 | wc -l)"
echo "- Поды: $(kubectl get pods --namespace=task5 2>/dev/null | grep -v NAME | wc -l)"
echo "- Сервисы: $(kubectl get services --namespace=task5 2>/dev/null | grep -v NAME | wc -l)"
echo "- NetworkPolicy: $(kubectl get networkpolicies --namespace=task5 2>/dev/null | grep -v NAME | wc -l)"
echo ""
echo "Система готова к использованию!"
echo "Для очистки: ./04_cleanup_task5.sh"
