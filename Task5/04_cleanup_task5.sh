#!/bin/bash

# Очистка всех ресурсов Task 5

echo "=== Очистка ресурсов Task 5 ==="

echo "Удаление подов..."
kubectl delete pods --all --namespace=task5 || true

echo "Удаление сервисов..."
kubectl delete services --all --namespace=task5 || true

echo "Удаление сетевых политик..."
kubectl delete networkpolicies --all --namespace=task5 || true

echo "Удаление namespace..."
kubectl delete namespace task5 || true

echo "Удаление файлов конфигурации..."
rm -f default-deny-all.yaml || true
rm -f network-policies.yaml || true

echo "Очистка завершена!"
echo ""
echo "Все ресурсы Task 5 удалены:"
echo "- Поды и сервисы"
echo "- Сетевые политики"
echo "- Namespace task5"
echo "- Конфигурационные файлы"
