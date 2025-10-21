#!/bin/bash

# Создание пользователей PropDevelopment

echo "Создание пользователей..."

# Создаем директорию для сертификатов
mkdir -p ./users-certs
cd ./users-certs

# Список пользователей
users=(
    "security-admin:security-team"
    "devops-engineer:devops-team"
    "developer:development-team"
    "data-analyst:data-team"
    "accountant:finance-team"
    "manager:management-team"
    "client-support:support-team"
    "owner-support:tenant-support-team"
    "smart-home-operator:smart-home-team"
    "external-partner:external"
)

# Создаем пользователей
for user_info in "${users[@]}"; do
    IFS=':' read -r username team <<< "$user_info"
    echo "Создание пользователя: $username"
    
    # Генерируем ключ
    openssl genrsa -out $username.key 2048 >/dev/null 2>&1
    
    # Создаем запрос на сертификат
    openssl req -new -key $username.key -out $username.csr -subj "/CN=$username/O=propdevelopment/O=$team" >/dev/null 2>&1
    
    # Подписываем сертификат
    openssl x509 -req -in $username.csr -CA ~/.minikube/ca.crt -CAkey ~/.minikube/ca.key -CAcreateserial -out $username.crt -days 365 >/dev/null 2>&1
    
    # Настраиваем kubeconfig
    kubectl config set-credentials $username --client-certificate=$username.crt --client-key=$username.key >/dev/null 2>&1
    kubectl config set-context $username --cluster=minikube --user=$username >/dev/null 2>&1
done

# Настраиваем namespace для пользователей
kubectl config set-context security-admin --namespace=security >/dev/null 2>&1
kubectl config set-context devops-engineer --namespace=sales >/dev/null 2>&1
kubectl config set-context developer --namespace=tenant-services >/dev/null 2>&1
kubectl config set-context data-analyst --namespace=data >/dev/null 2>&1
kubectl config set-context accountant --namespace=finance >/dev/null 2>&1
kubectl config set-context manager --namespace=monitoring >/dev/null 2>&1
kubectl config set-context client-support --namespace=sales >/dev/null 2>&1
kubectl config set-context owner-support --namespace=tenant-services >/dev/null 2>&1
kubectl config set-context smart-home-operator --namespace=smart-home >/dev/null 2>&1
kubectl config set-context external-partner --namespace=smart-home >/dev/null 2>&1

echo "Пользователи созданы"
