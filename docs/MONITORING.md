# Мониторинг: Prometheus + Grafana + Telegram

## 🚀 Компоненты

| Компонент | URL | Назначение |
|-----------|-----|-----------|
| Prometheus | http://50.114.58.91:9090 | Метрики (CPU, RAM, Disk) |
| Node Exporter | http://50.114.58.91:9100 | Данные с системы |
| Grafana | http://50.114.58.91:3000 | Графики (admin/admin) |
| Telegram Bot | @BotFather | Алерты при сбое |

## 📊 Prometheus - Метрики

### Быстрые ссылки
- **CPU:** http://50.114.58.91:9090/graph?g0.expr=node_cpu_seconds_total
- **Memory:** http://50.114.58.91:9090/graph?g0.expr=node_memory_MemAvailable_bytes
- **Disk:** http://50.114.58.91:9090/graph?g0.expr=node_filesystem_avail_bytes
- **V2Ray port:** http://50.114.58.91:9090/graph?g0.expr=probe_success

### Как пользоваться
1. Открываешь http://50.114.58.91:9090
2. Graph → вводишь метрику
3. Выбираешь время (1h, 6h, 24h)
4. Смотришь график

## 🔔 Telegram Bot - Алерты

### Как работает
- Проверяет V2Ray каждую минуту
- Если V2Ray упадёт → сообщение в Telegram

### Конфиг
```bash
ssh root@50.114.58.91 "cat /etc/v2ray-telegram/bot.env"
# BOT_TOKEN="8691502685:AAFHBitL0iS_0gE9c9mC7qJupCJU1OA-Smo"
# CHAT_ID="7952038621"
```

### Тест
```bash
ssh root@50.114.58.91 "systemctl stop v2ray && sleep 60"
# В Telegram придёт алерт ⚠️
ssh root@50.114.58.91 "systemctl start v2ray"
```

## 📈 Grafana - Графики

### Доступ
- URL: http://50.114.58.91:3000
- Login: admin / admin

### Если не работает
```bash
ssh root@50.114.58.91 << 'FIX'
cd /opt/monitoring
docker rm grafana -f
docker compose up -d grafana
sleep 10
docker ps | grep grafana
FIX
```

### Создать dashboard
1. Create → Dashboard
2. Add Panel
3. Data source: Prometheus
4. Metrics: node_memory_MemAvailable_bytes
5. Save

