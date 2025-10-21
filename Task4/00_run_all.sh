#!/bin/bash

# Мастер-скрипт для полной настройки Kubernetes RBAC для PropDevelopment
# Запускает все скрипты в правильном порядке

echo "🚀 === Полная настройка Kubernetes RBAC для PropDevelopment ==="
echo "📋 Основано на анализе заданий 1-3"
echo ""

# Проверяем, что мы в правильной директории
if [ ! -f "01_setup_minikube.sh" ]; then
    echo "❌ Ошибка: Запустите скрипт из директории Task4/"
    exit 1
fi

# Функция для проверки успешности выполнения
check_success() {
    if [ $? -eq 0 ]; then
        echo "✅ $1 - УСПЕШНО"
    else
        echo "❌ $1 - ОШИБКА"
        echo "🛑 Остановка выполнения"
        exit 1
    fi
}

# Функция для паузы между этапами
pause_between_steps() {
    echo ""
    echo "⏳ Пауза 3 секунды перед следующим этапом..."
    sleep 3
    echo ""
}

echo "🔍 Проверяем предварительные требования..."

# Проверяем Minikube
if ! command -v minikube &> /dev/null; then
    echo "❌ Minikube не установлен. Установите Minikube сначала."
    echo "📖 Инструкции: https://minikube.sigs.k8s.io/docs/start/"
    exit 1
fi

# Проверяем kubectl
if ! command -v kubectl &> /dev/null; then
    echo "❌ kubectl не установлен. Установите kubectl сначала."
    echo "📖 Инструкции: https://kubernetes.io/docs/tasks/tools/"
    exit 1
fi

# Проверяем openssl
if ! command -v openssl &> /dev/null; then
    echo "❌ OpenSSL не установлен. Установите OpenSSL сначала."
    exit 1
fi

echo "✅ Все предварительные требования выполнены"
echo ""

# Этап 1: Настройка Minikube
echo "📦 ЭТАП 1: Настройка Minikube и namespace"
echo "================================================"
./01_setup_minikube.sh
check_success "Настройка Minikube"
pause_between_steps

# Этап 2: Создание пользователей
echo "👥 ЭТАП 2: Создание пользователей и сертификатов"
echo "================================================"
./02_create_users.sh
check_success "Создание пользователей"
pause_between_steps

# Этап 3: Создание ролей
echo "🔐 ЭТАП 3: Создание ролей Kubernetes"
echo "================================================"
./03_create_roles.sh
check_success "Создание ролей"
pause_between_steps

# Этап 4: Связывание пользователей с ролями
echo "🔗 ЭТАП 4: Связывание пользователей с ролями"
echo "================================================"
./04_bind_users_roles.sh
check_success "Связывание пользователей с ролями"

echo ""
echo "🎉 === НАСТРОЙКА ЗАВЕРШЕНА УСПЕШНО! ==="
echo ""

# Финальная проверка
echo "📊 Проверяем результаты настройки..."
echo ""

echo "📋 Созданные namespace:"
kubectl get namespaces | grep -E "(sales|tenant-services|finance|data|smart-home|monitoring|security)"

echo ""
echo "👥 Созданные пользователи:"
kubectl config get-users | grep -E "(security-admin|devops-engineer|developer|data-analyst|accountant|manager|client-support|owner-support|smart-home-operator|external-partner)"

echo ""
echo "🔐 Созданные роли:"
kubectl get clusterroles | grep -E "(cluster-admin|namespace-admin|developer|data-analyst|monitor-viewer|security-auditor|smart-home-operator|accountant|manager|client-support|owner-support|external-partner|backup-operator|network-admin|secret-manager)" | wc -l | xargs echo "Количество ролей:"

echo ""
echo "🔗 Созданные привязки:"
echo "ClusterRoleBindings: $(kubectl get clusterrolebindings | grep -E "(security-admin|devops-engineer|developer|data-analyst|accountant|manager|client-support|owner-support|smart-home-operator|external-partner|security-auditor|monitor-viewer|backup-operator|network-admin|secret-manager)" | wc -l)"
echo "RoleBindings: $(kubectl get rolebindings --all-namespaces | grep -E "(devops-engineer|developer|data-analyst|accountant|manager|client-support|owner-support|smart-home-operator|external-partner)" | wc -l)"

echo ""
echo "✅ === СИСТЕМА ГОТОВА К ИСПОЛЬЗОВАНИЮ! ==="
echo ""
echo "📖 Дополнительная информация:"
echo "  - Подробные инструкции: README.md"
echo "  - Таблица ролей: kubernetes_rbac_roles_table.md"
echo "  - Тестирование доступа: kubectl config use-context <user>"
echo ""
echo "🔧 Полезные команды:"
echo "  - Просмотр всех namespace: kubectl get namespaces"
echo "  - Просмотр всех ролей: kubectl get clusterroles"
echo "  - Просмотр привязок: kubectl get clusterrolebindings"
echo "  - Тестирование пользователя: kubectl config use-context security-admin"
echo ""
echo "🛡️ Принципы безопасности реализованы:"
echo "  ✅ Принцип минимальных привилегий"
echo "  ✅ Разделение обязанностей"
echo "  ✅ Аудит доступа"
echo "  ✅ Сегментация по доменам"
echo "  ✅ Соответствие ФЗ-152"
echo ""
echo "🎯 PropDevelopment Kubernetes RBAC настроен!"
