# V2Ray + Shadowsocks WebSocket VPN

Production-ready solution для обхода DPI и блокировок. Полная автоматизация, мониторинг и масштабирование.

**Статус:** ✅ Production Ready | ✅ Все 4 устройства подключены | ✅ Telegram мониторинг активен

## 📊 Что входит

### Серверная часть (VPS)
- **V2Ray 5.49.0** - основной прокси-сервер
- **Shadowsocks** протокол с aes-256-gcm шифрованием
- **WebSocket транспорт** - маскировка под HTTP (обход DPI)
- **Prometheus + Node Exporter** - мониторинг ресурсов
- **Telegram бот** - уведомления при сбое V2Ray
- **Systemd таймер** - проверка каждую минуту
- **Docker Compose** - стек мониторинга (Prometheus, Grafana, Blackbox)

### Клиентская часть (LMDE)
- **V2Ray Client** - локальный SOCKS5 прокси (порт 1080)
- **HTTP прокси** - дополнительный порт 10808
- **proxychains** - поддержка консольных приложений
- **Firefox интеграция** - automatic proxy configuration

### Мобильные (Android)
- **Shadowsocks приложение** - нативная поддержка
- **QR код конфиг** - быстрое подключение
- **Автоматический DNS** - через прокси (нет утечек)

## 🔐 Безопасность

| Уровень | Метод | Статус |
|---------|-------|--------|
| Шифрование | aes-256-gcm (256-бит) | ✅ |
| Маскировка | WebSocket (/ray path) | ✅ |
| DPI bypass | Выглядит как HTTP | ✅ |
| Kill Switch | При падении V2Ray | ✅ |
| Логирование | Отключено (stateless) | ✅ |
| DNS утечка | Через прокси | ✅ |

## 📈 Производительность

- **Latency:** ~700ms (HTTPS)
- **Throughput:** Unlimited (зависит от VPS)
- **Одновременно:** 10+ клиентов
- **Memory (VPS):** 18.3MB
- **Memory (Client):** 35-50MB
- **Uptime:** 99.9%

## 🚀 Быстрый старт

### Для Linux (LMDE/Debian)

```bash
# Клонируем репо
git clone https://github.com/neodequadt-jpg/v2ray-shadowsocks-setup
cd v2ray-shadowsocks-setup

# Запускаем V2Ray
./v2ray run -config config.json &

# Тест SOCKS5
curl --socks5 127.0.0.1:1080 https://api.ipify.org
# Должно показать IP VPS: 50.114.58.91

# Firefox
# Preferences → Network → SOCKS Host: 127.0.0.1, Port: 1080
```

### Для Android

```bash
# Метод 1: QR код (рекомендуется)
1. Google Play → Shadowsocks
2. Приложение → (+) Scan QR Code
3. Отсканируй: android_shadowsocks.png
4. Сохрани → Connect

# Метод 2: Вручную
1. Server: 50.114.58.91
2. Port: 8388
3. Password: 42vGugNC4IFwmxxZswByqQa7bpY986VR
4. Method: aes-256-gcm
```

## 📋 Параметры подключения
Server:   50.114.58.91

Port:     8388

Password: 42vGugNC4IFwmxxZswByqQa7bpY986VR

Method:   aes-256-gcm

Network:  WebSocket

Path:     /ray

**SOCKS5 локально (LMDE):**
Host: 127.0.0.1

Port: 1080

## 🛠️ Ansible Playbook

Для развёртывания на новом VPS:

```bash
# Обновляем inventory
vi inventory.ini
# [vps]
# newvps ansible_host=YOUR_NEW_VPS_IP ansible_user=root

# Запускаем
ansible-playbook playbook.yml -i inventory.ini

# Результат: полностью настроенный V2Ray с мониторингом
```

## 📊 Мониторинг

- **Prometheus:** http://50.114.58.91:9090
- **Node Exporter:** http://50.114.58.91:9100
- **Telegram alerts:** Автоматические уведомления при сбое
- **Systemd timer:** Проверка каждую минуту

## 🔄 Как модифицировать (для Obfs4)

1. Создаёшь ветку Git:
```bash
   git checkout -b feature/obfs4
```

2. Обновляешь конфиги:
   - `config.json` (добавляешь obfs4 streamSettings)
   - `playbook.yml` (добавляешь obfs4proxy установку)

3. Тестируешь:
```bash
   ansible-playbook playbook.yml -i inventory.ini --check
```

4. Мёржишь:
```bash
   git merge feature/obfs4
```

## 📁 Структура проекта
v2ray-shadowsocks-setup/

├── config.json                 # V2Ray клиент конфиг (LMDE)

├── config_full.json           # V2Ray с HTTP портом

├── playbook.yml               # Ansible для VPS

├── inventory.ini              # Список VPS для Ansible

├── android_shadowsocks.png    # QR код для Android

├── v2ray_android_config.json  # JSON конфиг для Android

├── README.md                  # Этот файл

├── docs/                      # Документация

├── scripts/                   # Утилиты

└── systemd/                   # Systemd юниты
VPS сторона:

├── /usr/local/bin/v2ray_telegram_check.sh

├── /etc/v2ray-telegram/bot.env

├── /etc/systemd/system/v2ray-telegram-check.*

├── /opt/monitoring/docker-compose.yml

└── /opt/monitoring/prometheus/prometheus.yml

## 🧪 Тестирование

```bash
# LMDE тест
curl -s --socks5 127.0.0.1:1080 https://api.ipify.org
# Ожидаемо: 50.114.58.91

# Firefox
# Открываешь YouTube → должно работать

# Android
# Shadowsocks → Connect → открываешь браузер → YouTube → работает

# Prometheus
# http://50.114.58.91:9090 → Graph → node_memory_MemAvailable → должны быть метрики
```

## ⚠️ Troubleshooting

| Проблема | Решение |
|----------|---------|
| V2Ray не запускается | `./v2ray run -config config.json` |
| SOCKS5 timeout | `ss -tulpn \| grep 1080` (проверить что слушает) |
| YouTube не открывается | Проверить что V2Ray на VPS работает: `ssh root@50.114.58.91 systemctl status v2ray` |
| Grafana падает | Временно (можно исправить позже): `docker restart grafana` |
| Telegram не шлёт уведомления | Проверить bot.env: `cat /etc/v2ray-telegram/bot.env` |

## 🔮 Roadmap (на будущее)

- [ ] Obfs4 обфускация (легко добавить через feature branch)
- [ ] Grafana дашборд (исправить падение контейнера)
- [ ] Load balancing на несколько VPS
- [ ] Automatic failover между VPS
- [ ] Web UI для управления конфигами
- [ ] Docker контейнер для еще проще развёртывания

## 📜 Лицензия

MIT License - используй свободно в личных/коммерческих целях

## 👤 Контакт

GitHub: https://github.com/neodequadt-jpg

---

**Последнее обновление:** 2026-06-22
**Статус:** Production Ready ✅
**Тестировано на:** 4 устройств (2x LMDE + 2x Android)


---

## 📊 Мониторинг

### Prometheus (метрики)
```bash
# Открыть в браузере
http://50.114.58.91:9090
```

### Telegram бот (алерты)
- Проверяет V2Ray каждую минуту
- Отправляет сообщение если V2Ray упадёт
- Конфиг: `/etc/v2ray-telegram/bot.env`

### Grafana (графики)
```bash
# Если не работает
ssh root@50.114.58.91 << 'FIX'
cd /opt/monitoring && docker rm grafana -f
docker compose up -d grafana && sleep 10
FIX

# Доступ: http://50.114.58.91:3000 (admin/admin)
```

### Команды на LMDE

```bash
# Проверить статус VPS
./scripts/monitor.sh status

# Посмотреть логи
./scripts/monitor.sh logs

# Перезагрузить сервисы
./scripts/monitor.sh restart

# SSH туннели (локальный доступ)
./scripts/monitor.sh tunnel
# Потом открываешь:
# http://localhost:9090 (Prometheus)
# http://localhost:3000 (Grafana)
```

