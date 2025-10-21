#!/bin/bash

# Создание сетевых политик для изоляции трафика

echo "=== Создание сетевых политик ==="

# Создаем сетевую политику для разрешения трафика между front-end и back-end-api
cat > non-admin-api-allow.yaml << 'EOF'
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: non-admin-api-allow
  namespace: task5
spec:
  podSelector:
    matchLabels:
      role: front-end
  policyTypes:
  - Ingress
  - Egress
  ingress:
  - from:
    - podSelector:
        matchLabels:
          role: back-end-api
    ports:
    - protocol: TCP
      port: 80
  egress:
  # Разрешаем DNS
  - to: []
    ports:
    - protocol: UDP
      port: 53
  # Разрешаем подключение к back-end-api
  - to:
    - podSelector:
        matchLabels:
          role: back-end-api
    ports:
    - protocol: TCP
      port: 80
---
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: back-end-api-allow
  namespace: task5
spec:
  podSelector:
    matchLabels:
      role: back-end-api
  policyTypes:
  - Ingress
  - Egress
  ingress:
  - from:
    - podSelector:
        matchLabels:
          role: front-end
    ports:
    - protocol: TCP
      port: 80
  egress:
  # Разрешаем DNS
  - to: []
    ports:
    - protocol: UDP
      port: 53
  # Разрешаем подключение к front-end
  - to:
    - podSelector:
        matchLabels:
          role: front-end
    ports:
    - protocol: TCP
      port: 80
---
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: admin-api-allow
  namespace: task5
spec:
  podSelector:
    matchLabels:
      role: admin-front-end
  policyTypes:
  - Ingress
  - Egress
  ingress:
  - from:
    - podSelector:
        matchLabels:
          role: admin-back-end-api
    ports:
    - protocol: TCP
      port: 80
  egress:
  # Разрешаем DNS
  - to: []
    ports:
    - protocol: UDP
      port: 53
  # Разрешаем подключение к admin-back-end-api
  - to:
    - podSelector:
        matchLabels:
          role: admin-back-end-api
    ports:
    - protocol: TCP
      port: 80
---
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: admin-back-end-api-allow
  namespace: task5
spec:
  podSelector:
    matchLabels:
      role: admin-back-end-api
  policyTypes:
  - Ingress
  - Egress
  ingress:
  - from:
    - podSelector:
        matchLabels:
          role: admin-front-end
    ports:
    - protocol: TCP
      port: 80
  egress:
  # Разрешаем DNS
  - to: []
    ports:
    - protocol: UDP
      port: 53
  # Разрешаем подключение к admin-front-end
  - to:
    - podSelector:
        matchLabels:
          role: admin-front-end
    ports:
    - protocol: TCP
      port: 80
EOF

# Создаем политику "deny all" по умолчанию
cat > default-deny-all.yaml << 'EOF'
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: default-deny-all
  namespace: task5
spec:
  podSelector: {}
  policyTypes:
  - Ingress
  - Egress
EOF

echo "Применение сетевых политик..."
kubectl apply -f default-deny-all.yaml >/dev/null 2>&1
kubectl apply -f non-admin-api-allow.yaml >/dev/null 2>&1

echo "Сетевые политики созданы и применены!"
echo ""
echo "Созданные NetworkPolicy:"
kubectl get networkpolicies --namespace=task5
