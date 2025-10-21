#!/bin/bash

# Скрипт для создания пользователей PropDevelopment
# Основан на ролевой модели из заданий 1-3

echo "=== Создание пользователей PropDevelopment ==="

# Создаем директорию для сертификатов пользователей
mkdir -p ./users-certs
cd ./users-certs

echo "🔐 Создаем пользователей на основе организационной структуры PropDevelopment..."

# 1. Создаем пользователя для специалиста по ИБ (cluster-admin)
echo "👤 Создаем пользователя: security-admin"
openssl genrsa -out security-admin.key 2048
openssl req -new -key security-admin.key -out security-admin.csr -subj "/CN=security-admin/O=propdevelopment/O=security-team"
openssl x509 -req -in security-admin.csr -CA ~/.minikube/ca.crt -CAkey ~/.minikube/ca.key -CAcreateserial -out security-admin.crt -days 365

# 2. Создаем пользователя для DevOps-инженера (namespace-admin)
echo "👤 Создаем пользователя: devops-engineer"
openssl genrsa -out devops-engineer.key 2048
openssl req -new -key devops-engineer.key -out devops-engineer.csr -subj "/CN=devops-engineer/O=propdevelopment/O=devops-team"
openssl x509 -req -in devops-engineer.csr -CA ~/.minikube/ca.crt -CAkey ~/.minikube/ca.key -CAcreateserial -out devops-engineer.crt -days 365

# 3. Создаем пользователя для разработчика (developer)
echo "👤 Создаем пользователя: developer"
openssl genrsa -out developer.key 2048
openssl req -new -key developer.key -out developer.csr -subj "/CN=developer/O=propdevelopment/O=development-team"
openssl x509 -req -in developer.csr -CA ~/.minikube/ca.crt -CAkey ~/.minikube/ca.key -CAcreateserial -out developer.crt -days 365

# 4. Создаем пользователя для аналитика данных (data-analyst)
echo "👤 Создаем пользователя: data-analyst"
openssl genrsa -out data-analyst.key 2048
openssl req -new -key data-analyst.key -out data-analyst.csr -subj "/CN=data-analyst/O=propdevelopment/O=data-team"
openssl x509 -req -in data-analyst.csr -CA ~/.minikube/ca.crt -CAkey ~/.minikube/ca.key -CAcreateserial -out data-analyst.crt -days 365

# 5. Создаем пользователя для бухгалтера (accountant)
echo "👤 Создаем пользователя: accountant"
openssl genrsa -out accountant.key 2048
openssl req -new -key accountant.key -out accountant.csr -subj "/CN=accountant/O=propdevelopment/O=finance-team"
openssl x509 -req -in accountant.csr -CA ~/.minikube/ca.crt -CAkey ~/.minikube/ca.key -CAcreateserial -out accountant.crt -days 365

# 6. Создаем пользователя для менеджера (manager)
echo "👤 Создаем пользователя: manager"
openssl genrsa -out manager.key 2048
openssl req -new -key manager.key -out manager.csr -subj "/CN=manager/O=propdevelopment/O=management-team"
openssl x509 -req -in manager.csr -CA ~/.minikube/ca.crt -CAkey ~/.minikube/ca.key -CAcreateserial -out manager.crt -days 365

# 7. Создаем пользователя для специалиста поддержки клиентов (client-support)
echo "👤 Создаем пользователя: client-support"
openssl genrsa -out client-support.key 2048
openssl req -new -key client-support.key -out client-support.csr -subj "/CN=client-support/O=propdevelopment/O=support-team"
openssl x509 -req -in client-support.csr -CA ~/.minikube/ca.crt -CAkey ~/.minikube/ca.key -CAcreateserial -out client-support.crt -days 365

# 8. Создаем пользователя для специалиста поддержки собственников (owner-support)
echo "👤 Создаем пользователя: owner-support"
openssl genrsa -out owner-support.key 2048
openssl req -new -key owner-support.key -out owner-support.csr -subj "/CN=owner-support/O=propdevelopment/O=tenant-support-team"
openssl x509 -req -in owner-support.csr -CA ~/.minikube/ca.crt -CAkey ~/.minikube/ca.key -CAcreateserial -out owner-support.crt -days 365

# 9. Создаем пользователя для оператора Smart Home (smart-home-operator)
echo "👤 Создаем пользователя: smart-home-operator"
openssl genrsa -out smart-home-operator.key 2048
openssl req -new -key smart-home-operator.key -out smart-home-operator.csr -subj "/CN=smart-home-operator/O=propdevelopment/O=smart-home-team"
openssl x509 -req -in smart-home-operator.csr -CA ~/.minikube/ca.crt -CAkey ~/.minikube/ca.key -CAcreateserial -out smart-home-operator.crt -days 365

# 10. Создаем пользователя для внешнего партнёра (external-partner)
echo "👤 Создаем пользователя: external-partner"
openssl genrsa -out external-partner.key 2048
openssl req -new -key external-partner.key -out external-partner.csr -subj "/CN=external-partner/O=smart-home-partner/O=external"
openssl x509 -req -in external-partner.csr -CA ~/.minikube/ca.crt -CAkey ~/.minikube/ca.key -CAcreateserial -out external-partner.crt -days 365

echo "📋 Создаем kubeconfig файлы для пользователей..."

# Создаем kubeconfig для security-admin
kubectl config set-credentials security-admin --client-certificate=security-admin.crt --client-key=security-admin.key
kubectl config set-context security-admin --cluster=minikube --user=security-admin
kubectl config set-context security-admin --namespace=security

# Создаем kubeconfig для devops-engineer
kubectl config set-credentials devops-engineer --client-certificate=devops-engineer.crt --client-key=devops-engineer.key
kubectl config set-context devops-engineer --cluster=minikube --user=devops-engineer
kubectl config set-context devops-engineer --namespace=sales

# Создаем kubeconfig для developer
kubectl config set-credentials developer --client-certificate=developer.crt --client-key=developer.key
kubectl config set-context developer --cluster=minikube --user=developer
kubectl config set-context developer --namespace=tenant-services

# Создаем kubeconfig для data-analyst
kubectl config set-credentials data-analyst --client-certificate=data-analyst.crt --client-key=data-analyst.key
kubectl config set-context data-analyst --cluster=minikube --user=data-analyst
kubectl config set-context data-analyst --namespace=data

# Создаем kubeconfig для accountant
kubectl config set-credentials accountant --client-certificate=accountant.crt --client-key=accountant.key
kubectl config set-context accountant --cluster=minikube --user=accountant
kubectl config set-context accountant --namespace=finance

# Создаем kubeconfig для manager
kubectl config set-credentials manager --client-certificate=manager.crt --client-key=manager.key
kubectl config set-context manager --cluster=minikube --user=manager
kubectl config set-context manager --namespace=monitoring

# Создаем kubeconfig для client-support
kubectl config set-credentials client-support --client-certificate=client-support.crt --client-key=client-support.key
kubectl config set-context client-support --cluster=minikube --user=client-support
kubectl config set-context client-support --namespace=sales

# Создаем kubeconfig для owner-support
kubectl config set-credentials owner-support --client-certificate=owner-support.crt --client-key=owner-support.key
kubectl config set-context owner-support --cluster=minikube --user=owner-support
kubectl config set-context owner-support --namespace=tenant-services

# Создаем kubeconfig для smart-home-operator
kubectl config set-credentials smart-home-operator --client-certificate=smart-home-operator.crt --client-key=smart-home-operator.key
kubectl config set-context smart-home-operator --cluster=minikube --user=smart-home-operator
kubectl config set-context smart-home-operator --namespace=smart-home

# Создаем kubeconfig для external-partner
kubectl config set-credentials external-partner --client-certificate=external-partner.crt --client-key=external-partner.key
kubectl config set-context external-partner --cluster=minikube --user=external-partner
kubectl config set-context external-partner --namespace=smart-home

echo "📊 Проверяем созданных пользователей..."
kubectl config get-users

echo "✅ Пользователи PropDevelopment созданы!"
echo "📁 Сертификаты сохранены в директории: ./users-certs/"
echo "🔐 Kubeconfig файлы настроены для каждого пользователя"
echo ""
echo "👥 Созданные пользователи:"
echo "  - security-admin (Специалист по ИБ)"
echo "  - devops-engineer (DevOps-инженер)"
echo "  - developer (Разработчик)"
echo "  - data-analyst (Аналитик данных)"
echo "  - accountant (Бухгалтер)"
echo "  - manager (Менеджер)"
echo "  - client-support (Поддержка клиентов)"
echo "  - owner-support (Поддержка собственников)"
echo "  - smart-home-operator (Оператор Smart Home)"
echo "  - external-partner (Внешний партнёр)"
