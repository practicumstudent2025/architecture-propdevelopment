#!/bin/bash

# Развертывание сервисов для Task 5 - Управление трафиком

echo "=== Развертывание сервисов PropDevelopment ==="

# Создаем namespace для Task 5
echo "Создание namespace..."
kubectl create namespace task5

# Создаем ServiceAccount для namespace
echo "Создание ServiceAccount..."
kubectl create serviceaccount default --namespace=task5

# Создаем YAML файлы для Deployment
echo "Создание YAML файлов для Deployment..."

# Front-end deployment
cat > front-end-deployment.yaml << 'EOF'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: front-end-app
  namespace: task5
  labels:
    role: front-end
spec:
  replicas: 1
  selector:
    matchLabels:
      role: front-end
  template:
    metadata:
      labels:
        role: front-end
    spec:
      containers:
      - name: nginx
        image: nginx
        ports:
        - containerPort: 80
---
apiVersion: v1
kind: Service
metadata:
  name: front-end-app
  namespace: task5
spec:
  selector:
    role: front-end
  ports:
  - port: 80
    targetPort: 80
EOF

# Back-end-api deployment
cat > back-end-api-deployment.yaml << 'EOF'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: back-end-api-app
  namespace: task5
  labels:
    role: back-end-api
spec:
  replicas: 1
  selector:
    matchLabels:
      role: back-end-api
  template:
    metadata:
      labels:
        role: back-end-api
    spec:
      containers:
      - name: nginx
        image: nginx
        ports:
        - containerPort: 80
---
apiVersion: v1
kind: Service
metadata:
  name: back-end-api-app
  namespace: task5
spec:
  selector:
    role: back-end-api
  ports:
  - port: 80
    targetPort: 80
EOF

# Admin-front-end deployment
cat > admin-front-end-deployment.yaml << 'EOF'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: admin-front-end-app
  namespace: task5
  labels:
    role: admin-front-end
spec:
  replicas: 1
  selector:
    matchLabels:
      role: admin-front-end
  template:
    metadata:
      labels:
        role: admin-front-end
    spec:
      containers:
      - name: nginx
        image: nginx
        ports:
        - containerPort: 80
---
apiVersion: v1
kind: Service
metadata:
  name: admin-front-end-app
  namespace: task5
spec:
  selector:
    role: admin-front-end
  ports:
  - port: 80
    targetPort: 80
EOF

# Admin-back-end-api deployment
cat > admin-back-end-api-deployment.yaml << 'EOF'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: admin-back-end-api-app
  namespace: task5
  labels:
    role: admin-back-end-api
spec:
  replicas: 1
  selector:
    matchLabels:
      role: admin-back-end-api
  template:
    metadata:
      labels:
        role: admin-back-end-api
    spec:
      containers:
      - name: nginx
        image: nginx
        ports:
        - containerPort: 80
---
apiVersion: v1
kind: Service
metadata:
  name: admin-back-end-api-app
  namespace: task5
spec:
  selector:
    role: admin-back-end-api
  ports:
  - port: 80
    targetPort: 80
EOF

# Применяем все deployment
echo "Развертывание front-end сервиса..."
kubectl apply -f front-end-deployment.yaml

echo "Развертывание back-end-api сервиса..."
kubectl apply -f back-end-api-deployment.yaml

echo "Развертывание admin-front-end сервиса..."
kubectl apply -f admin-front-end-deployment.yaml

echo "Развертывание admin-back-end-api сервиса..."
kubectl apply -f admin-back-end-api-deployment.yaml

# Ждем готовности подов
echo "Ожидание готовности подов..."
kubectl wait --for=condition=Ready pods --all --namespace=task5 --timeout=60s

# Проверяем наличие curl в подах
echo "Проверка curl в подах..."
for pod in front-end-app back-end-api-app admin-front-end-app admin-back-end-api-app; do
    echo "Проверка curl в $pod..."
    kubectl exec $pod --namespace=task5 -- which curl || echo "curl не найден в $pod"
done

echo "Сервисы развернуты успешно!"
echo ""
echo "Созданные сервисы:"
kubectl get pods --namespace=task5
echo ""
echo "Созданные сервисы (services):"
kubectl get services --namespace=task5
