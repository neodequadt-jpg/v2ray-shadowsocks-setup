# Полная инструкция по Мониторингу

## 📊 Компоненты мониторинга

### 1️⃣ PROMETHEUS (метрики ресурсов)
### 2️⃣ GRAFANA (красивые графики)
### 3️⃣ TELEGRAM БОТ (алерты при сбое)
### 4️⃣ NODE EXPORTER (сбор данных с VPS)

---

## 🚀 БЫСТРЫЙ СТАРТ

### На VPS

```bash
# Проверяем что всё запущено
ssh root@50.114.58.91 "docker ps -a"

# Должно быть:
# - prometheus (Up)
# - node-exporter (Up)
# - blackbox-exporter (Up)
# - grafana (может быть Restarting, но это OK)
```

---

## 1️⃣ PROMETHEUS - Сбор метрик

### Что это?
- Временная база данных для метрик
- Собирает CPU, Memory, Disk, Network
- Проверяет доступность портов (8388)
- Интервал: каждые 15 секунд

### Доступ
URL: http://50.114.58.91:9090

### Что смотреть

#### CPU использование
Меню → Graph → Поиск: "node_cpu_seconds_total"

#### Память
Меню → Graph → Поиск: "node_memory_MemAvailable_bytes"

Делишь на 1024^3 чтобы получить GB

#### Диск
Меню → Graph → Поиск: "node_filesystem_avail_bytes"

#### V2Ray порт (8388) доступен?
Меню → Graph → Поиск: "probe_success"

Если = 1 → порт доступен ✓

Если = 0 → порт заблокирован ❌

### Как читать графики
Наверху слева: Time range (1h, 6h, 24h, 7d)

Нажимаешь → выбираешь период
Graph (линия) показывает изменение во времени

Table показывает конкретные значения

### Примеры запросов
CPU за последний час
rate(node_cpu_seconds_total{mode="system"}[5m])
Память доступная (в GB)
node_memory_MemAvailable_bytes / 1024 / 1024 / 1024
Disk usage
(node_filesystem_size_bytes - node_filesystem_avail_bytes) / node_filesystem_size_bytes
V2Ray доступен
probe_success{job="blackbox_v2ray_port"}

---

## 2️⃣ TELEGRAM БОТ - Алерты

### Что это?
- Автоматические уведомления в Telegram
- Проверяет V2Ray каждую минуту
- Если V2Ray упадёт → вам приходит сообщение

### Как работает

На VPS запущен таймер:
```bash
systemctl status v2ray-telegram-check.timer
```

Каждую минуту выполняет:
```bash
/usr/local/bin/v2ray_telegram_check.sh
```

Скрипт проверяет:
```bash
systemctl is-active v2ray
```

Если статус ≠ "active" → отправляет сообщение в Telegram

### Конфиг бота

На VPS в файле:
```bash
cat /etc/v2ray-telegram/bot.env

# Результат:
# BOT_TOKEN="8691502685:AAFHBitL0iS_0gE9c9mC7qJupCJU1OA-Smo"
# CHAT_ID="7952038621"
# SERVICE_NAME="v2ray"
```

### Тест бота

```bash
# На VPS - отправь тестовое сообщение
curl -s -X POST "https://api.telegram.org/bot8691502685:AAFHBitL0iS_0gE9c9mC7qJupCJU1OA-Smo/sendMessage" \
  -d "chat_id=7952038621" \
  -d "text=🧪 Тест Telegram бота - всё работает!"

# Должно прийти сообщение в Telegram ✓
```

### Проверка алертов

```bash
# На VPS - выключи V2Ray
systemctl stop v2ray

# Жди 1 минуту (когда таймер сработает)

# В Telegram должно прийти:
# "⚠️ V2Ray сервис 'v2ray' НЕ АКТИВЕН на хосте: 84297.koara.live. Статус: inactive"

# Включи V2Ray обратно
systemctl start v2ray

# Жди 1 минуту - алерт не придёт (V2Ray снова работает)
```

### Логи бота

```bash
# На VPS - смотри логи срабатываний
journalctl -u v2ray-telegram-check.service -n 20

# Результат:
# Jun 22 01:05:04 v2ray-telegram-check.service - Check V2Ray and send Telegram alert.
# Jun 22 01:05:04 v2ray-telegram-check.service: Deactivated successfully.
```

---

## 3️⃣ GRAFANA - Красивые графики (ИСПРАВЛЕНИЕ)

### Статус сейчас
❌ Grafana контейнер падает (Restarting (1))

### Почему падает?
Скорее всего проблема с volume или инициализацией БД.

### Как исправить (простой способ)

```bash
# На VPS - пересоздаём контейнер
ssh root@50.114.58.91 << 'FIXGRAFANA'

cd /opt/monitoring

# Удаляем старый контейнер
docker rm grafana -f 2>/dev/null

# Проверяем что удалился
docker ps | grep grafana || echo "✅ Удален"

# Запускаем снова через docker-compose
docker compose up -d grafana

# Ждём 10 секунд инициализации
sleep 10

# Проверяем статус
docker ps | grep grafana

FIXGRAFANA

echo ""
echo "✅ Grafana должна работать"
```

### Доступ к Grafana
URL: http://50.114.58.91:3000

Username: admin

Password: admin (дефолт)

### После входа

1. **Добавляешь Prometheus как Data Source**
   - Configuration → Data Sources → Add data source
   - Type: Prometheus
   - URL: http://prometheus:9090
   - Save & Test

2. **Создаёшь первый Dashboard**
   - Create → Dashboard → Add Panel
   - Metrics: выбираешь из Prometheus (например node_memory_MemAvailable_bytes)
   - Customise graph (цвета, названия)

3. **Примеры панелей для V2Ray мониторинга**

   **CPU usage (%):**
100 - (avg by (instance) (irate(node_cpu_seconds_total{mode="idle"}[5m])) * 100)

   **Memory usage (%):**
(1 - (node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes)) * 100

   **Disk usage (%):**
(node_filesystem_size_bytes{fstype!="tmpfs"} - node_filesystem_avail_bytes) / node_filesystem_size_bytes * 100

   **V2Ray port status:**
probe_success{job="blackbox_v2ray_port"}

---

## 📋 СКРИПТЫ ДЛЯ УПРАВЛЕНИЯ

### На VPS

#### 1. Проверка всех компонентов

```bash
#!/bin/bash
# scripts/check-all.sh

echo "════════════════════════════════════════"
echo "  VPS Monitoring Status"
echo "════════════════════════════════════════"

echo ""
echo "✅ V2Ray Service:"
systemctl status v2ray --no-pager | grep Active

echo ""
echo "✅ Docker Containers:"
docker ps -a --format "table {{.Names}}\t{{.Status}}"

echo ""
echo "✅ Prometheus:"
curl -s http://localhost:9090/-/healthy || echo "❌ Not responding"

echo ""
echo "✅ Node Exporter:"
curl -s http://localhost:9100/metrics | head -5 && echo "..." || echo "❌ Not responding"

echo ""
echo "✅ Telegram Bot Config:"
cat /etc/v2ray-telegram/bot.env

echo ""
echo "✅ Systemd Timer:"
systemctl status v2ray-telegram-check.timer --no-pager | grep Active

echo ""
echo "✅ Ports Listening:"
ss -tulpn | grep -E "8388|9090|9100|3000"
```

#### 2. Перезагрузка всех сервисов

```bash
#!/bin/bash
# scripts/restart-all.sh

echo "Перезагружаю все сервисы..."

# V2Ray
systemctl restart v2ray
echo "✅ V2Ray restarted"

# Telegram check
systemctl restart v2ray-telegram-check.timer
echo "✅ Telegram timer restarted"

# Docker
cd /opt/monitoring
docker compose restart
echo "✅ Docker services restarted"

echo ""
echo "Waiting 10 seconds for services to start..."
sleep 10

# Проверяем
./check-all.sh
```

#### 3. Просмотр логов

```bash
#!/bin/bash
# scripts/logs.sh

echo "════════════════════════════════════════"
echo "  V2Ray Logs (последние 50 строк)"
echo "════════════════════════════════════════"
journalctl -u v2ray -n 50 --no-pager

echo ""
echo "════════════════════════════════════════"
echo "  Telegram Check Logs (последние 20)"
echo "════════════════════════════════════════"
journalctl -u v2ray-telegram-check.service -n 20 --no-pager

echo ""
echo "════════════════════════════════════════"
echo "  Docker Logs (Prometheus)"
echo "════════════════════════════════════════"
docker logs prometheus --tail 20

echo ""
echo "════════════════════════════════════════"
echo "  Docker Logs (Grafana)"
echo "════════════════════════════════════════"
docker logs grafana --tail 20
```

---

## 📱 НА LMDE - ДИСТАНЦИОННЫЙ МОНИТОРИНГ

### Через SSH туннель

```bash
# Открываешь туннель к Prometheus
ssh -L 9090:localhost:9090 root@50.114.58.91 -N &

# Открываешь туннель к Grafana
ssh -L 3000:localhost:3000 root@50.114.58.91 -N &

# Теперь доступно локально:
# Prometheus: http://localhost:9090
# Grafana: http://localhost:3000
```

### Или через Firefox на VPS (если X-forwarding)

```bash
ssh -X root@50.114.58.91
firefox http://localhost:3000 &
```

---

## 🔔 НАСТРОЙКА TELEGRAM БОТА

### Если нужно изменить настройки

```bash
# На VPS - отредактируй конфиг
nano /etc/v2ray-telegram/bot.env

# Внеси изменения:
# BOT_TOKEN="новый_токен"
# CHAT_ID="новый_id"

# Перезагрузи таймер
systemctl restart v2ray-telegram-check.timer

# Тест
/usr/local/bin/v2ray_telegram_check.sh
```

### Получить новый токен

1. Telegram → @BotFather
2. /mybots → выбери бота
3. API Token → скопируй новый

### Получить новый Chat ID

1. Telegram → @userinfobot
2. /start
3. Вернёт твой User ID

---

## 📊 ПРИМЕР ПОЛНОГО ДАШБОРДА

### После исправления Grafana, создаёшь панели:

1. **System Overview**
   - CPU usage
   - Memory usage
   - Disk usage
   - Network traffic

2. **V2Ray Health**
   - Service status (binary: 1=up, 0=down)
   - Port availability (8388)
   - Connection count
   - Error rate

3. **Alerts**
   - Last alert time
   - Alert frequency
   - Bot health

---

## ⚡ QUICK COMMANDS

```bash
# На VPS - полная диагностика
ssh root@50.114.58.91 << 'DIAG'
echo "=== V2Ray ===" && systemctl status v2ray --no-pager | head -5
echo "" && echo "=== Docker ===" && docker ps -a --format "table {{.Names}}\t{{.Status}}"
echo "" && echo "=== Prometheus ===" && curl -s http://localhost:9090/api/v1/status/tsdb
echo "" && echo "=== Telegram ===" && cat /etc/v2ray-telegram/bot.env
DIAG
```

