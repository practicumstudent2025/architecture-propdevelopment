# Task 4: Защита доступа к кластеру Kubernetes для PropDevelopment

## Описание

Этот набор скриптов реализует ролевую модель доступа к кластеру Kubernetes для компании PropDevelopment на основе анализа заданий 1-3.

## Требования
- **Docker** - обязательно для работы Minikube
- **Minikube** - локальный Kubernetes кластер
- **kubectl** - утилита для работы с Kubernetes
- **OpenSSL** - для создания сертификатов пользователей

## Структура файлов

- `00_run_all.sh` - **Мастер-скрипт для полной настройки** (рекомендуется)
- `kubernetes_rbac_roles_table.md` - Таблица ролей и их полномочий
- `01_setup_minikube.sh` - Скрипт для поднятия пустого Minikube
- `02_create_users.sh` - Скрипт для создания пользователей (10 пользователей)
- `03_create_roles.sh` - Скрипт для создания ролей Kubernetes (16 ролей)
- `04_bind_users_roles.sh` - Скрипт для связывания пользователей с ролями
- `05_fix_cluster.sh` - Скрипт для исправления проблем с кластером
- `06_cleanup_all.sh` - **Скрипт для полной очистки всех ресурсов**

## Порядок выполнения

### 🚀 Быстрый старт (рекомендуется)
```bash
# Запустите мастер-скрипт для полной настройки
./00_run_all.sh
```

Мастер-скрипт автоматически выполнит все этапы в правильном порядке:
1. Проверка предварительных требований
2. Настройка Minikube и namespace
3. Создание пользователей и сертификатов
4. Создание ролей Kubernetes
5. Связывание пользователей с ролями
6. Финальная проверка результатов

### 📋 Ручное выполнение (пошагово)

#### 1. Подготовка окружения
```bash
# Убедитесь, что Minikube установлен
minikube version

# Запустите скрипт настройки Minikube
./01_setup_minikube.sh
```

#### 2. Создание пользователей
```bash
# Создайте пользователей и их сертификаты
./02_create_users.sh
```

#### 3. Создание ролей
```bash
# Создайте роли Kubernetes
./03_create_roles.sh
```

#### 4. Связывание пользователей с ролями
```bash
# Привяжите пользователей к ролям
./04_bind_users_roles.sh
```

## Созданные пользователи

| Пользователь | Роль | Namespace | Описание |
|-------------|------|-----------|----------|
| security-admin | cluster-admin | security | Специалист по ИБ |
| devops-engineer | namespace-admin | sales, tenant-services, finance, data, smart-home | DevOps-инженер |
| developer | developer | tenant-services | Разработчик |
| data-analyst | data-analyst | data, finance | Аналитик данных |
| accountant | accountant | finance | Бухгалтер |
| manager | manager | monitoring, sales, tenant-services | Менеджер |
| client-support | client-support | sales | Поддержка клиентов |
| owner-support | owner-support | tenant-services | Поддержка собственников |
| smart-home-operator | smart-home-operator | smart-home | Оператор Smart Home |
| external-partner | external-partner | smart-home | Внешний партнёр |

## Созданные роли

### Основные роли
- **cluster-admin** - Полный доступ к кластеру
- **namespace-admin** - Управление ресурсами в namespace
- **developer** - Разработка приложений
- **data-analyst** - Анализ данных
- **monitor-viewer** - Мониторинг ресурсов
- **security-auditor** - Аудит безопасности
- **smart-home-operator** - Управление Smart Home
- **accountant** - Финансовый учёт
- **manager** - Управление бизнес-процессами
- **client-support** - Поддержка клиентов
- **owner-support** - Поддержка собственников
- **external-partner** - Внешние интеграции

### Дополнительные роли
- **backup-operator** - Резервное копирование
- **network-admin** - Управление сетью
- **secret-manager** - Управление секретами

## Namespace структура

```
propdevelopment/
├── sales/           # Группа сервисов для продаж
├── tenant-services/ # Группа сервисов ЖКУ
├── finance/         # Финансовый домен
├── data/           # Дата группа сервисов
├── smart-home/     # Smart Home сервисы
├── monitoring/     # Системы мониторинга
└── security/      # Системы безопасности
```

## Принципы безопасности

1. **Принцип минимальных привилегий** - пользователи получают только необходимые права
2. **Разделение обязанностей** - критические операции требуют нескольких ролей
3. **Аудит доступа** - все действия логируются
4. **Сегментация по доменам** - доступ ограничен соответствующими namespace
5. **Соответствие ФЗ-152** - контроль доступа к персональным данным

## Проверка настройки

### Проверка пользователей
```bash
kubectl config get-users
```

### Проверка ролей
```bash
kubectl get clusterroles | grep -E "(cluster-admin|namespace-admin|developer|data-analyst|monitor-viewer|security-auditor|smart-home-operator|accountant|manager|client-support|owner-support|external-partner|backup-operator|network-admin|secret-manager)"
```

### Проверка привязок
```bash
kubectl get clusterrolebindings
kubectl get rolebindings --all-namespaces
```

### Тестирование доступа
```bash
# Переключитесь на пользователя
kubectl config use-context security-admin

# Проверьте доступ
kubectl get pods --all-namespaces
```

## Соответствие требованиям

✅ **Ограничение доступа к управлению кластером** - реализовано через ролевую модель
✅ **Защита привилегированных действий** - секреты и конфигурации доступны только определённым ролям
✅ **Группы пользователей** - созданы группы для просмотра и настройки кластера
✅ **Разграничение по организационной структуре** - роли соответствуют доменам PropDevelopment

## Дополнительные возможности

- **NetworkPolicy** для изоляции namespace
- **Метки безопасности** для классификации данных
- **Группы пользователей** для масштабируемости
- **Cross-namespace доступ** для DevOps-инженеров
- **Аудит безопасности** для compliance

## Troubleshooting

### Проблемы с подключением к кластеру
```bash
# Если kubectl не может подключиться к кластеру
./05_fix_cluster.sh

# Или вручную:
# На macOS (если нет Docker):
minikube start --driver=hyperkit

# На Linux:
minikube start --driver=docker

# Проверка:
kubectl get nodes
```

### Проблемы с Docker
```bash
# 1. Убедитесь, что Docker Desktop установлен:
ls -la /Applications/ | grep -i docker

# 2. Запустите Docker Desktop:
open -a Docker

# 3. Подождите 30-60 секунд, пока Docker Desktop полностью запустится
# 4. Проверьте, что Docker работает:
docker --version
docker ps

# 5. Если Docker не найден в PATH, добавьте его:
echo 'export PATH="/Applications/Docker.app/Contents/Resources/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc

# 6. Проверьте, что Docker работает:
docker run hello-world
```

### Проблемы с Minikube
```bash
# Если Minikube не запускается с Docker:
minikube start --driver=docker --memory=4096 --cpus=2

# Проверьте статус:
minikube status
kubectl get nodes
```

### Проблемы с сертификатами
```bash
# Пересоздайте сертификаты
rm -rf ./users-certs
./02_create_users.sh
```

## Очистка системы

### Полная очистка всех ресурсов
```bash
# Удаляет все созданные ресурсы и останавливает Minikube
./06_cleanup_all.sh
```

Этот скрипт удаляет:
- Всех пользователей и их контексты
- Все роли и привязки Kubernetes
- Все namespace и NetworkPolicy
- Minikube кластер
- Сертификаты пользователей
- kubectl конфигурацию

### Проблемы с привязками
```bash
# Удалите все привязки
kubectl delete clusterrolebindings --all
kubectl delete rolebindings --all-namespaces

# Пересоздайте привязки
./04_bind_users_roles.sh
```

### Проблемы с namespace
```bash
# Пересоздайте namespace
kubectl delete namespace sales tenant-services finance data smart-home monitoring security
./01_setup_minikube.sh
```

### Полный сброс
```bash
# Остановите и удалите кластер
minikube stop
minikube delete

# Запустите мастер-скрипт заново
./00_run_all.sh
```

## Мастер-скрипт (00_run_all.sh)

### Использование мастер-скрипта
```bash
# Запуск полной настройки
./00_run_all.sh
```

Мастер-скрипт автоматически:
1. Проверит все зависимости
2. Настроит Minikube и namespace
3. Создаст пользователей и сертификаты
4. Создаст роли Kubernetes
5. Свяжет пользователей с ролями
6. Покажет статистику результатов

### Преимущества мастер-скрипта
- **Быстрота** - один скрипт вместо четырех
- **Надежность** - проверка каждого этапа
- **Безопасность** - остановка при ошибках
- **Удобство** - автоматическая последовательность
