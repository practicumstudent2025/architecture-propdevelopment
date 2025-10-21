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
    openssl genrsa -out $username.key 2048
    
    # Создаем запрос на сертификат
    openssl req -new -key $username.key -out $username.csr -subj "/CN=$username/O=propdevelopment/O=$team"
    
    # Подписываем сертификат
    openssl x509 -req -in $username.csr -CA ~/.minikube/ca.crt -CAkey ~/.minikube/ca.key -CAcreateserial -out $username.crt -days 365
    
    # Настраиваем kubeconfig
    kubectl config set-credentials $username --client-certificate=$username.crt --client-key=$username.key
    kubectl config set-context $username --cluster=minikube --user=$username
done

# Настраиваем namespace для пользователей
kubectl config set-context security-admin --namespace=security
kubectl config set-context devops-engineer --namespace=sales
kubectl config set-context developer --namespace=tenant-services
kubectl config set-context data-analyst --namespace=data
kubectl config set-context accountant --namespace=finance
kubectl config set-context manager --namespace=monitoring
kubectl config set-context client-support --namespace=sales
kubectl config set-context owner-support --namespace=tenant-services
kubectl config set-context smart-home-operator --namespace=smart-home
kubectl config set-context external-partner --namespace=smart-home

echo "Пользователи созданы"
