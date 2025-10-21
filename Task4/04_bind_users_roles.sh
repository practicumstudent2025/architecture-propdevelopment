#!/bin/bash

# Связывание пользователей с ролями PropDevelopment

echo "Связывание пользователей с ролями..."

# Связываем security-admin с cluster-admin
kubectl create clusterrolebinding security-admin-cluster-admin \
    --clusterrole=cluster-admin \
    --user=security-admin

# Связываем devops-engineer с namespace-admin для всех namespace
for ns in sales tenant-services finance data smart-home; do
  kubectl create rolebinding devops-engineer-$ns-admin \
      --clusterrole=namespace-admin \
      --user=devops-engineer \
      --namespace=$ns
done

# Связываем developer с developer ролью для tenant-services
kubectl create rolebinding developer-tenant-services \
    --clusterrole=developer \
    --user=developer \
    --namespace=tenant-services

# Связываем data-analyst с data-analyst ролью для data и finance
kubectl create rolebinding data-analyst-data \
    --clusterrole=data-analyst \
    --user=data-analyst \
    --namespace=data

kubectl create rolebinding data-analyst-finance \
    --clusterrole=data-analyst \
    --user=data-analyst \
    --namespace=finance

# Связываем accountant с accountant ролью для finance
kubectl create rolebinding accountant-finance \
    --clusterrole=accountant \
    --user=accountant \
    --namespace=finance

# Связываем manager с manager ролью для monitoring, sales, tenant-services
kubectl create rolebinding manager-monitoring \
    --clusterrole=manager \
    --user=manager \
    --namespace=monitoring

kubectl create rolebinding manager-sales \
    --clusterrole=manager \
    --user=manager \
    --namespace=sales

kubectl create rolebinding manager-tenant \
    --clusterrole=manager \
    --user=manager \
    --namespace=tenant-services

# Связываем client-support с client-support ролью для sales
kubectl create rolebinding client-support-sales \
    --clusterrole=client-support \
    --user=client-support \
    --namespace=sales

# Связываем owner-support с owner-support ролью для tenant-services
kubectl create rolebinding owner-support-tenant \
    --clusterrole=owner-support \
    --user=owner-support \
    --namespace=tenant-services

# Связываем smart-home-operator с smart-home-operator ролью для smart-home
kubectl create rolebinding smart-home-operator-smart-home \
    --clusterrole=smart-home-operator \
    --user=smart-home-operator \
    --namespace=smart-home

# Связываем external-partner с external-partner ролью для smart-home
kubectl create rolebinding external-partner-smart-home \
    --clusterrole=external-partner \
    --user=external-partner \
    --namespace=smart-home

# Создаем ClusterRoleBinding для дополнительных ролей
kubectl create clusterrolebinding security-auditor-cluster \
    --clusterrole=security-auditor \
    --user=security-admin

kubectl create clusterrolebinding monitor-viewer-cluster \
    --clusterrole=monitor-viewer \
    --user=manager

kubectl create clusterrolebinding backup-operator-cluster \
    --clusterrole=backup-operator \
    --user=devops-engineer

kubectl create clusterrolebinding network-admin-cluster \
    --clusterrole=network-admin \
    --user=devops-engineer

kubectl create clusterrolebinding secret-manager-cluster \
    --clusterrole=secret-manager \
    --user=security-admin

# Создаем привязки для групп пользователей
kubectl create clusterrolebinding security-team-cluster-admin \
    --clusterrole=cluster-admin \
    --group=security-team

kubectl create clusterrolebinding devops-team-namespace-admin \
    --clusterrole=namespace-admin \
    --group=devops-team

kubectl create clusterrolebinding development-team-developer \
    --clusterrole=developer \
    --group=development-team

kubectl create clusterrolebinding data-team-analyst \
    --clusterrole=data-analyst \
    --group=data-team

kubectl create clusterrolebinding finance-team-accountant \
    --clusterrole=accountant \
    --group=finance-team

kubectl create clusterrolebinding management-team-manager \
    --clusterrole=manager \
    --group=management-team

kubectl create clusterrolebinding support-team-client-support \
    --clusterrole=client-support \
    --group=support-team

kubectl create clusterrolebinding tenant-support-team-owner-support \
    --clusterrole=owner-support \
    --group=tenant-support-team

kubectl create clusterrolebinding smart-home-team-operator \
    --clusterrole=smart-home-operator \
    --group=smart-home-team

kubectl create clusterrolebinding external-partner-access \
    --clusterrole=external-partner \
    --group=external

echo "Привязки созданы"