#!/bin/bash

# Мастер-скрипт для настройки Kubernetes RBAC для PropDevelopment

echo "=== Настройка Kubernetes RBAC для PropDevelopment ==="

# Проверяем, что мы в правильной директории
if [ ! -f "01_setup_minikube.sh" ]; then
    echo "Ошибка: Запустите скрипт из директории Task4/"
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

# Проверяем Minikube
if ! command -v minikube &> /dev/null; then
    echo "Ошибка: Minikube не установлен"
    exit 1
fi

# Проверяем kubectl
if ! command -v kubectl &> /dev/null; then
    echo "Ошибка: kubectl не установлен"
    exit 1
fi

# Проверяем openssl
if ! command -v openssl &> /dev/null; then
    echo "Ошибка: OpenSSL не установлен"
    exit 1
fi

echo "Все требования выполнены"
echo ""

# Этап 1: Настройка Minikube
echo "Этап 1: Настройка Minikube"
./01_setup_minikube.sh
check_success "Настройка Minikube"

# Проверяем, что кластер готов
echo "Проверка готовности кластера..."
kubectl get nodes

# Этап 2: Создание пользователей
echo "Этап 2: Создание пользователей"
./02_create_users.sh
check_success "Создание пользователей"

# Этап 3: Создание ролей
echo "Этап 3: Создание ролей"
./03_create_roles.sh
check_success "Создание ролей"

# Этап 4: Связывание пользователей с ролями
echo "Этап 4: Связывание пользователей с ролями"
./04_bind_users_roles.sh
check_success "Связывание пользователей с ролями"

echo ""
echo "=== НАСТРОЙКА ЗАВЕРШЕНА ==="
echo ""

# Финальная проверка
echo "Результаты:"
echo "- Namespace: $(kubectl get namespaces | grep -E "(sales|tenant-services|finance|data|smart-home|monitoring|security)" | wc -l)"
echo "- Пользователи: $(kubectl config get-users | grep -E "(security-admin|devops-engineer|developer|data-analyst|accountant|manager|client-support|owner-support|smart-home-operator|external-partner)" | wc -l)"
echo "- Роли: $(kubectl get clusterroles | grep -E "(cluster-admin|namespace-admin|developer|data-analyst|monitor-viewer|security-auditor|smart-home-operator|accountant|manager|client-support|owner-support|external-partner|backup-operator|network-admin|secret-manager)" | wc -l)"
echo "- Привязки: $(kubectl get clusterrolebindings | grep -E "(security-admin|devops-engineer|developer|data-analyst|accountant|manager|client-support|owner-support|smart-home-operator|external-partner|security-auditor|monitor-viewer|backup-operator|network-admin|secret-manager)" | wc -l)"

echo ""
echo "Система готова к использованию!"
echo "Тестирование: kubectl config use-context security-admin"
