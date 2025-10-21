#!/bin/bash

# Тестирование сетевой связности между сервисами

echo "=== Тестирование сетевой связности ==="

# Функция для тестирования подключения
test_connection() {
    local from_pod=$1
    local to_service=$2
    local description=$3
    
    echo "Тестирование: $description"
    echo "От: $from_pod -> К: $to_service"
    
    # Тестируем изнутри существующего пода
    kubectl exec $from_pod --namespace=task5 -- sh -c "
        echo 'Проверка подключения к $to_service...'
        if curl -s --connect-timeout 5 http://$to_service; then
            echo '✅ Подключение успешно'
        else
            echo '❌ Подключение не удалось'
        fi
    "
    echo ""
}

echo "1. Тестирование разрешенных подключений:"
echo "=========================================="

# Тестируем front-end -> back-end-api (должно работать)
test_connection "front-end-app" "back-end-api-app" "front-end -> back-end-api (разрешено)"

# Тестируем admin-front-end -> admin-back-end-api (должно работать)
test_connection "admin-front-end-app" "admin-back-end-api-app" "admin-front-end -> admin-back-end-api (разрешено)"

echo "2. Тестирование запрещенных подключений:"
echo "=========================================="

# Тестируем front-end -> admin-back-end-api (должно быть запрещено)
test_connection "front-end-app" "admin-back-end-api-app" "front-end -> admin-back-end-api (запрещено)"

# Тестируем admin-front-end -> back-end-api (должно быть запрещено)
test_connection "admin-front-end-app" "back-end-api-app" "admin-front-end -> back-end-api (запрещено)"

echo "3. Проверка статуса подов:"
echo "=========================="
kubectl get pods --namespace=task5

echo ""
echo "4. Проверка сетевых политик:"
echo "============================"
kubectl get networkpolicies --namespace=task5

echo ""
echo "Тестирование завершено!"
