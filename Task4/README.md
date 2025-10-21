# Task 4: Защита доступа к кластеру Kubernetes для PropDevelopment

## Описание
Этот набор скриптов реализует ролевую модель доступа к кластеру Kubernetes для компании PropDevelopment.

## Требования
- **Docker** - обязательно для работы Minikube
- **Minikube** - локальный Kubernetes кластер
- **kubectl** - утилита для работы с Kubernetes
- **OpenSSL** - для создания сертификатов пользователей

## Структура файлов
- `00_run_all.sh` - **Мастер-скрипт для полной настройки** (рекомендуется)
- `01_setup_minikube.sh` - Настройка Minikube и namespace
- `02_create_users.sh` - Создание пользователей (10 пользователей)
- `03_create_roles.sh` - Создание ролей Kubernetes (16 ролей)
- `04_bind_users_roles.sh` - Связывание пользователей с ролями
- `05_fix_cluster.sh` - Исправление проблем с кластером
- `06_cleanup_all.sh` - **Полная очистка всех ресурсов**
- `kubernetes_rbac_roles_table.md` - Таблица ролей и их полномочий

## Быстрый старт
```bash
# Полная настройка
./00_run_all.sh

# Очистка системы
./06_cleanup_all.sh
```

## Созданные пользователи
- **security-admin** - администратор безопасности
- **devops-engineer** - DevOps инженер
- **developer** - разработчик
- **data-analyst** - аналитик данных
- **accountant** - бухгалтер
- **manager** - менеджер
- **client-support** - поддержка клиентов
- **owner-support** - поддержка собственников
- **smart-home-operator** - оператор умного дома
- **external-partner** - внешний партнер

## Namespace
- `sales` - продажи
- `tenant-services` - услуги арендаторам
- `finance` - финансы
- `data` - данные
- `smart-home` - умный дом
- `monitoring` - мониторинг
- `security` - безопасность

## Troubleshooting

### Проблемы с Docker
```bash
# Запустите Docker Desktop
open -a Docker

# Подождите 30-60 секунд, затем проверьте:
docker --version
docker ps
```

### Проблемы с Minikube
```bash
# Если Minikube не запускается:
./05_fix_cluster.sh

# Проверьте статус:
minikube status
kubectl get nodes
```

### Полная очистка
```bash
# Удаляет все созданные ресурсы
./06_cleanup_all.sh
```