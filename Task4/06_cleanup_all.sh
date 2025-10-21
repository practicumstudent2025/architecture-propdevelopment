#!/bin/bash

# Скрипт для полной очистки всех созданных ресурсов PropDevelopment

echo "=== Очистка всех ресурсов PropDevelopment ==="

# Функция для проверки успешности выполнения
check_success() {
    if [ $? -eq 0 ]; then
        echo "OK: $1"
    else
        echo "ОШИБКА: $1"
        exit 1
    fi
}

echo "Этап 1: Удаление пользователей и контекстов kubectl..."
# Удаляем всех пользователей из kubeconfig
users=(
    "security-admin"
    "devops-engineer" 
    "developer"
    "data-analyst"
    "accountant"
    "manager"
    "client-support"
    "owner-support"
    "smart-home-operator"
    "external-partner"
)

for user in "${users[@]}"; do
    kubectl config delete-user $user 2>/dev/null || true
    kubectl config delete-context $user 2>/dev/null || true
done

echo "Этап 2: Удаление ролей и привязок..."
# Удаляем ClusterRoleBindings
kubectl delete clusterrolebinding security-admin-binding 2>/dev/null || true
kubectl delete clusterrolebinding devops-engineer-binding 2>/dev/null || true
kubectl delete clusterrolebinding developer-binding 2>/dev/null || true
kubectl delete clusterrolebinding data-analyst-binding 2>/dev/null || true
kubectl delete clusterrolebinding accountant-binding 2>/dev/null || true
kubectl delete clusterrolebinding manager-binding 2>/dev/null || true
kubectl delete clusterrolebinding client-support-binding 2>/dev/null || true
kubectl delete clusterrolebinding owner-support-binding 2>/dev/null || true
kubectl delete clusterrolebinding smart-home-operator-binding 2>/dev/null || true
kubectl delete clusterrolebinding external-partner-binding 2>/dev/null || true
kubectl delete clusterrolebinding security-auditor-binding 2>/dev/null || true
kubectl delete clusterrolebinding monitor-viewer-binding 2>/dev/null || true
kubectl delete clusterrolebinding backup-operator-binding 2>/dev/null || true
kubectl delete clusterrolebinding network-admin-binding 2>/dev/null || true
kubectl delete clusterrolebinding secret-manager-binding 2>/dev/null || true

# Удаляем RoleBindings
kubectl delete rolebinding devops-engineer-sales-binding -n sales 2>/dev/null || true
kubectl delete rolebinding developer-tenant-binding -n tenant-services 2>/dev/null || true
kubectl delete rolebinding data-analyst-data-binding -n data 2>/dev/null || true
kubectl delete rolebinding accountant-finance-binding -n finance 2>/dev/null || true
kubectl delete rolebinding manager-monitoring-binding -n monitoring 2>/dev/null || true
kubectl delete rolebinding client-support-sales-binding -n sales 2>/dev/null || true
kubectl delete rolebinding owner-support-tenant-binding -n tenant-services 2>/dev/null || true
kubectl delete rolebinding smart-home-operator-smart-home-binding -n smart-home 2>/dev/null || true
kubectl delete rolebinding external-partner-smart-home-binding -n smart-home 2>/dev/null || true

echo "Этап 3: Удаление ролей..."
# Удаляем ClusterRoles
kubectl delete clusterrole cluster-admin 2>/dev/null || true
kubectl delete clusterrole namespace-admin 2>/dev/null || true
kubectl delete clusterrole developer 2>/dev/null || true
kubectl delete clusterrole data-analyst 2>/dev/null || true
kubectl delete clusterrole monitor-viewer 2>/dev/null || true
kubectl delete clusterrole security-auditor 2>/dev/null || true
kubectl delete clusterrole smart-home-operator 2>/dev/null || true
kubectl delete clusterrole accountant 2>/dev/null || true
kubectl delete clusterrole manager 2>/dev/null || true
kubectl delete clusterrole client-support 2>/dev/null || true
kubectl delete clusterrole owner-support 2>/dev/null || true
kubectl delete clusterrole external-partner 2>/dev/null || true
kubectl delete clusterrole backup-operator 2>/dev/null || true
kubectl delete clusterrole network-admin 2>/dev/null || true
kubectl delete clusterrole secret-manager 2>/dev/null || true

echo "Этап 4: Удаление namespace..."
# Удаляем все созданные namespace
kubectl delete namespace sales 2>/dev/null || true
kubectl delete namespace tenant-services 2>/dev/null || true
kubectl delete namespace finance 2>/dev/null || true
kubectl delete namespace data 2>/dev/null || true
kubectl delete namespace smart-home 2>/dev/null || true
kubectl delete namespace monitoring 2>/dev/null || true
kubectl delete namespace security 2>/dev/null || true

echo "Этап 5: Остановка и удаление Minikube..."
# Останавливаем и удаляем Minikube
minikube stop 2>/dev/null || true
minikube delete 2>/dev/null || true

echo "Этап 6: Очистка сертификатов..."
# Удаляем директорию с сертификатами
rm -rf ./users-certs 2>/dev/null || true

echo "Этап 7: Сброс kubectl конфигурации..."
# Удаляем контекст minikube
kubectl config delete-context minikube 2>/dev/null || true
kubectl config delete-cluster minikube 2>/dev/null || true

echo ""
echo "=== ОЧИСТКА ЗАВЕРШЕНА ==="
echo ""
echo "Все ресурсы PropDevelopment удалены:"
echo "- Пользователи и контексты kubectl"
echo "- Роли и привязки Kubernetes"
echo "- Namespace и NetworkPolicy"
echo "- Minikube кластер"
echo "- Сертификаты пользователей"
echo ""
echo "Система полностью очищена!"
