#!/bin/bash

# Создание сетевых политик для изоляции трафика

echo "=== Создание сетевых политик ==="

# Создаем упрощенные сетевые политики
cat > network-policies.yaml << 'EOF'
# Политика для front-end и back-end-api
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: frontend-backend-allow
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
  - to: []
    ports:
    - protocol: UDP
      port: 53
  - to:
    - podSelector:
        matchLabels:
          role: back-end-api
    ports:
    - protocol: TCP
      port: 80
---
# Политика для admin-front-end и admin-back-end-api
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: admin-frontend-backend-allow
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
  - to: []
    ports:
    - protocol: UDP
      port: 53
  - to:
    - podSelector:
        matchLabels:
          role: admin-back-end-api
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
# Удаляем все существующие политики
kubectl delete networkpolicy --all --namespace=task5 >/dev/null 2>&1 || true
# Сначала применяем политику "deny all"
kubectl apply -f default-deny-all.yaml >/dev/null 2>&1
# Затем применяем разрешающие политики
kubectl apply -f network-policies.yaml >/dev/null 2>&1

echo "Сетевые политики созданы и применены!"
echo ""
echo "Созданные NetworkPolicy:"
kubectl get networkpolicies --namespace=task5
