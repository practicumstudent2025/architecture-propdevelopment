#!/bin/bash

# Очистка всех ресурсов Task 5

echo "=== Очистка ресурсов Task 5 ==="

echo "Удаление подов..."
kubectl delete pods --all --namespace=task5 2>/dev/null || true

echo "Удаление сервисов..."
kubectl delete services --all --namespace=task5 2>/dev/null || true

echo "Удаление сетевых политик..."
kubectl delete networkpolicies --all --namespace=task5 2>/dev/null || true

echo "Удаление namespace..."
kubectl delete namespace task5 2>/dev/null || true

echo "Удаление файлов конфигурации..."
rm -f default-deny-all.yaml 2>/dev/null || true
rm -f network-policies.yaml 2>/dev/null || true

echo "Очистка завершена!"
echo ""
echo "Все ресурсы Task 5 удалены:"
echo "- Поды и сервисы"
echo "- Сетевые политики"
echo "- Namespace task5"
echo "- Конфигурационные файлы"
