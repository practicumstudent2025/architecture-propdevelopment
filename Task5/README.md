# Task 5: Управление трафиком внутри кластера Kubernetes

## Описание
Этот набор скриптов реализует изоляцию трафика между сервисами в кластере Kubernetes для PropDevelopment.

## Требования
- **Kubernetes кластер** - Minikube или другой кластер
- **kubectl** - утилита для работы с Kubernetes

## Структура файлов
- `00_run_all.sh` - **Мастер-скрипт для полной настройки** (рекомендуется)
- `01_deploy_services.sh` - Развертывание 4 сервисов с метками
- `02_create_network_policies.sh` - Создание сетевых политик
- `03_test_connectivity.sh` - Тестирование связности
- `04_cleanup_task5.sh` - **Полная очистка всех ресурсов**

## Быстрый старт
```bash
# Полная настройка
./00_run_all.sh

# Очистка системы
./04_cleanup_task5.sh
```

## Созданные сервисы
- **front-end-app** - фронтенд приложение (role=front-end)
- **back-end-api-app** - API бэкенд (role=back-end-api)
- **admin-front-end-app** - админ фронтенд (role=admin-front-end)
- **admin-back-end-api-app** - админ API (role=admin-back-end-api)

## Сетевые политики
- **non-admin-api-allow** - разрешает трафик front-end ↔ back-end-api
- **admin-api-allow** - разрешает трафик admin-front-end ↔ admin-back-end-api
- **back-end-api-allow** - обратная связь для back-end-api
- **admin-back-end-api-allow** - обратная связь для admin-back-end-api

## Namespace
- `task5` - изолированное пространство для тестирования

## Troubleshooting

### Проблемы с кластером
```bash
# Убедитесь, что кластер запущен
kubectl get nodes

# Если Minikube не запущен:
minikube start
```

### Проблемы с подключением
```bash
# Проверьте статус подов
kubectl get pods --namespace=task5

# Проверьте сетевые политики
kubectl get networkpolicies --namespace=task5
```

### Полная очистка
```bash
# Удаляет все созданные ресурсы
./04_cleanup_task5.sh
```
