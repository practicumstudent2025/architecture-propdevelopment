#!/bin/bash

# Очистка всех ресурсов Task 5

echo "=== Очистка ресурсов Task 5 ==="

echo "Удаление подов..."
kubectl delete pod front-end-app --namespace=task5 2>/dev/null || true
kubectl delete pod back-end-api-app --namespace=task5 2>/dev/null || true
kubectl delete pod admin-front-end-app --namespace=task5 2>/dev/null || true
kubectl delete pod admin-back-end-api-app --namespace=task5 2>/dev/null || true

echo "Удаление сервисов..."
kubectl delete service front-end-app --namespace=task5 2>/dev/null || true
kubectl delete service back-end-api-app --namespace=task5 2>/dev/null || true
kubectl delete service admin-front-end-app --namespace=task5 2>/dev/null || true
kubectl delete service admin-back-end-api-app --namespace=task5 2>/dev/null || true

echo "Удаление сетевых политик..."
kubectl delete networkpolicy non-admin-api-allow --namespace=task5 2>/dev/null || true
kubectl delete networkpolicy back-end-api-allow --namespace=task5 2>/dev/null || true
kubectl delete networkpolicy admin-api-allow --namespace=task5 2>/dev/null || true
kubectl delete networkpolicy admin-back-end-api-allow --namespace=task5 2>/dev/null || true

echo "Удаление namespace..."
kubectl delete namespace task5 2>/dev/null || true

echo "Удаление файлов конфигурации..."
rm -f non-admin-api-allow.yaml 2>/dev/null || true

echo "Очистка завершена!"
echo ""
echo "Все ресурсы Task 5 удалены:"
echo "- Поды и сервисы"
echo "- Сетевые политики"
echo "- Namespace task5"
echo "- Конфигурационные файлы"
