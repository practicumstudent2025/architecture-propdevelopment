# Task 5: Управление трафиком в Kubernetes с сетевыми политиками

## Описание
Развертывание четырех сервисов Nginx в одном namespace с настройкой сетевых политик для сегментации трафика между API сервисами и их UI компонентами.

## Требования

### Системные требования
- Kubernetes кластер (локальный или удаленный)
- kubectl настроен и подключен к кластеру
- Docker (для Minikube)

### Для локальной разработки с Minikube
- Minikube установлен
- Docker Desktop запущен

### Для Apple Silicon (M1/M2/M3)
Скрипт оптимизирован для работы на Apple Silicon с использованием:
- Docker-драйвера Minikube
- Kubernetes v1.30.0 (стабильная версия)
- Calico CNI для Network Policies
- Автоматическая очистка перед запуском

## Использование

### Запуск скрипта
```bash
cd Task5
./01_deploy_services.sh
```

### Запуск с полной очисткой
```bash
cd Task5
./01_deploy_services.sh --clean
```

### Что создается
- Namespace: `task5`
- 4 Deployment с метками:
  - `front-end` (UI для обычных пользователей)
  - `back-end-api` (API для обычных пользователей)
  - `admin-front-end` (UI для администраторов)
  - `admin-back-end-api` (API для администраторов)
- 4 Service для каждого deployment
- Сетевые политики для сегментации трафика:
  - Разрешен трафик: `front-end` ↔ `back-end-api`
  - Разрешен трафик: `admin-front-end` ↔ `admin-back-end-api`
  - Заблокирован трафик между разными парами сервисов

### Проверка результата
```bash
# Проверить поды
kubectl get pods --namespace=task5

# Проверить сервисы
kubectl get services --namespace=task5

# Проверить сетевые политики
kubectl get networkpolicies --namespace=task5
```

### Автоматическое тестирование
Скрипт автоматически выполняет тесты сетевых политик:
- ✅ `front-end` → `back-end-api` (должно работать)
- ✅ `admin-front-end` → `admin-back-end-api` (должно работать)
- ❌ `front-end` → `admin-back-end-api` (должно быть заблокировано)
- ❌ `admin-front-end` → `back-end-api` (должно быть заблокировано)

## Файлы проекта

### Основные файлы
- `01_deploy_services.sh` - Основной скрипт развертывания и тестирования
- `non-admin-api-allow.yaml` - Сетевые политики для сегментации трафика
- `deploy_services.yaml` - Манифесты для развертывания сервисов

### Отдельные манифесты (опционально)
- `front-end-deployment.yaml` - Deployment для front-end
- `back-end-api-deployment.yaml` - Deployment для back-end-api
- `admin-front-end-deployment.yaml` - Deployment для admin-front-end
- `admin-back-end-api-deployment.yaml` - Deployment для admin-back-end-api

## Очистка
```bash
kubectl delete namespace task5
```

## Устранение неполадок

### Ошибка подключения к кластеру
```bash
# Запустить Minikube
minikube start

# Проверить статус
kubectl get nodes
```

### Namespace уже существует
Скрипт автоматически удалит существующий namespace `task5` перед созданием нового.
