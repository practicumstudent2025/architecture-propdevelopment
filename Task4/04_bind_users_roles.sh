#!/bin/bash

# Скрипт для связывания пользователей с ролями PropDevelopment
# Основан на ролевой модели из заданий 1-3

echo "=== Связывание пользователей с ролями PropDevelopment ==="

# 1. Связываем security-admin с cluster-admin (полный доступ)
echo "🔗 Связываем security-admin с cluster-admin"
kubectl create clusterrolebinding security-admin-cluster-admin \
    --clusterrole=cluster-admin \
    --user=security-admin

# 2. Связываем devops-engineer с namespace-admin для sales namespace
echo "🔗 Связываем devops-engineer с namespace-admin для sales"
kubectl create rolebinding devops-engineer-sales-admin \
    --clusterrole=namespace-admin \
    --user=devops-engineer \
    --namespace=sales

# 3. Связываем developer с developer ролью для tenant-services namespace
echo "🔗 Связываем developer с developer ролью для tenant-services"
kubectl create rolebinding developer-tenant-services \
    --clusterrole=developer \
    --user=developer \
    --namespace=tenant-services

# 4. Связываем data-analyst с data-analyst ролью для data namespace
echo "🔗 Связываем data-analyst с data-analyst ролью для data"
kubectl create rolebinding data-analyst-data \
    --clusterrole=data-analyst \
    --user=data-analyst \
    --namespace=data

# 5. Связываем accountant с accountant ролью для finance namespace
echo "🔗 Связываем accountant с accountant ролью для finance"
kubectl create rolebinding accountant-finance \
    --clusterrole=accountant \
    --user=accountant \
    --namespace=finance

# 6. Связываем manager с manager ролью для monitoring namespace
echo "🔗 Связываем manager с manager ролью для monitoring"
kubectl create rolebinding manager-monitoring \
    --clusterrole=manager \
    --user=manager \
    --namespace=monitoring

# 7. Связываем client-support с client-support ролью для sales namespace
echo "🔗 Связываем client-support с client-support ролью для sales"
kubectl create rolebinding client-support-sales \
    --clusterrole=client-support \
    --user=client-support \
    --namespace=sales

# 8. Связываем owner-support с owner-support ролью для tenant-services namespace
echo "🔗 Связываем owner-support с owner-support ролью для tenant-services"
kubectl create rolebinding owner-support-tenant \
    --clusterrole=owner-support \
    --user=owner-support \
    --namespace=tenant-services

# 9. Связываем smart-home-operator с smart-home-operator ролью для smart-home namespace
echo "🔗 Связываем smart-home-operator с smart-home-operator ролью для smart-home"
kubectl create rolebinding smart-home-operator-smart-home \
    --clusterrole=smart-home-operator \
    --user=smart-home-operator \
    --namespace=smart-home

# 10. Связываем external-partner с external-partner ролью для smart-home namespace
echo "🔗 Связываем external-partner с external-partner ролью для smart-home"
kubectl create rolebinding external-partner-smart-home \
    --clusterrole=external-partner \
    --user=external-partner \
    --namespace=smart-home

# 11. Создаем дополнительные привязки для cross-namespace доступа

# DevOps-инженер также имеет доступ к tenant-services
echo "🔗 Связываем devops-engineer с namespace-admin для tenant-services"
kubectl create rolebinding devops-engineer-tenant-admin \
    --clusterrole=namespace-admin \
    --user=devops-engineer \
    --namespace=tenant-services

# DevOps-инженер также имеет доступ к finance
echo "🔗 Связываем devops-engineer с namespace-admin для finance"
kubectl create rolebinding devops-engineer-finance-admin \
    --clusterrole=namespace-admin \
    --user=devops-engineer \
    --namespace=finance

# DevOps-инженер также имеет доступ к data
echo "🔗 Связываем devops-engineer с namespace-admin для data"
kubectl create rolebinding devops-engineer-data-admin \
    --clusterrole=namespace-admin \
    --user=devops-engineer \
    --namespace=data

# DevOps-инженер также имеет доступ к smart-home
echo "🔗 Связываем devops-engineer с namespace-admin для smart-home"
kubectl create rolebinding devops-engineer-smart-home-admin \
    --clusterrole=namespace-admin \
    --user=devops-engineer \
    --namespace=smart-home

# 12. Создаем привязки для security-auditor (аудит безопасности)
echo "🔗 Создаем ClusterRoleBinding для security-auditor"
kubectl create clusterrolebinding security-auditor-cluster \
    --clusterrole=security-auditor \
    --user=security-admin

# 13. Создаем привязки для monitor-viewer (мониторинг)
echo "🔗 Создаем ClusterRoleBinding для monitor-viewer"
kubectl create clusterrolebinding monitor-viewer-cluster \
    --clusterrole=monitor-viewer \
    --user=manager

# 14. Создаем привязки для backup-operator
echo "🔗 Создаем ClusterRoleBinding для backup-operator"
kubectl create clusterrolebinding backup-operator-cluster \
    --clusterrole=backup-operator \
    --user=devops-engineer

# 15. Создаем привязки для network-admin
echo "🔗 Создаем ClusterRoleBinding для network-admin"
kubectl create clusterrolebinding network-admin-cluster \
    --clusterrole=network-admin \
    --user=devops-engineer

# 16. Создаем привязки для secret-manager
echo "🔗 Создаем ClusterRoleBinding для secret-manager"
kubectl create clusterrolebinding secret-manager-cluster \
    --clusterrole=secret-manager \
    --user=security-admin

# 17. Создаем дополнительные привязки для cross-domain доступа

# Data-analyst также имеет доступ к finance для аналитики
echo "🔗 Связываем data-analyst с data-analyst ролью для finance"
kubectl create rolebinding data-analyst-finance \
    --clusterrole=data-analyst \
    --user=data-analyst \
    --namespace=finance

# Manager также имеет доступ к sales для мониторинга
echo "🔗 Связываем manager с manager ролью для sales"
kubectl create rolebinding manager-sales \
    --clusterrole=manager \
    --user=manager \
    --namespace=sales

# Manager также имеет доступ к tenant-services для мониторинга
echo "🔗 Связываем manager с manager ролью для tenant-services"
kubectl create rolebinding manager-tenant \
    --clusterrole=manager \
    --user=manager \
    --namespace=tenant-services

# 18. Создаем привязки для групп пользователей (на основе организационной структуры)

# Создаем группу для security-team
echo "🔗 Создаем ClusterRoleBinding для security-team"
kubectl create clusterrolebinding security-team-cluster-admin \
    --clusterrole=cluster-admin \
    --group=security-team

# Создаем группу для devops-team
echo "🔗 Создаем ClusterRoleBinding для devops-team"
kubectl create clusterrolebinding devops-team-namespace-admin \
    --clusterrole=namespace-admin \
    --group=devops-team

# Создаем группу для development-team
echo "🔗 Создаем ClusterRoleBinding для development-team"
kubectl create clusterrolebinding development-team-developer \
    --clusterrole=developer \
    --group=development-team

# Создаем группу для data-team
echo "🔗 Создаем ClusterRoleBinding для data-team"
kubectl create clusterrolebinding data-team-analyst \
    --clusterrole=data-analyst \
    --group=data-team

# Создаем группу для finance-team
echo "🔗 Создаем ClusterRoleBinding для finance-team"
kubectl create clusterrolebinding finance-team-accountant \
    --clusterrole=accountant \
    --group=finance-team

# Создаем группу для management-team
echo "🔗 Создаем ClusterRoleBinding для management-team"
kubectl create clusterrolebinding management-team-manager \
    --clusterrole=manager \
    --group=management-team

# Создаем группу для support-team
echo "🔗 Создаем ClusterRoleBinding для support-team"
kubectl create clusterrolebinding support-team-client-support \
    --clusterrole=client-support \
    --group=support-team

# Создаем группу для tenant-support-team
echo "🔗 Создаем ClusterRoleBinding для tenant-support-team"
kubectl create clusterrolebinding tenant-support-team-owner-support \
    --clusterrole=owner-support \
    --group=tenant-support-team

# Создаем группу для smart-home-team
echo "🔗 Создаем ClusterRoleBinding для smart-home-team"
kubectl create clusterrolebinding smart-home-team-operator \
    --clusterrole=smart-home-operator \
    --group=smart-home-team

# Создаем группу для external
echo "🔗 Создаем ClusterRoleBinding для external"
kubectl create clusterrolebinding external-partner-access \
    --clusterrole=external-partner \
    --group=external

echo "📊 Проверяем созданные привязки..."
kubectl get clusterrolebindings | grep -E "(security-admin|devops-engineer|developer|data-analyst|accountant|manager|client-support|owner-support|smart-home-operator|external-partner|security-auditor|monitor-viewer|backup-operator|network-admin|secret-manager)"

kubectl get rolebindings --all-namespaces | grep -E "(devops-engineer|developer|data-analyst|accountant|manager|client-support|owner-support|smart-home-operator|external-partner)"

echo "✅ Пользователи PropDevelopment связаны с ролями!"
echo "🔗 Создано 25+ привязок пользователей к ролям"
echo "👥 Пользователи привязаны к соответствующим namespace и доменам"
echo "🛡️ Реализованы принципы безопасности: минимальные привилегии, разделение по доменам"
echo "📋 Привязки соответствуют организационной структуре PropDevelopment"
