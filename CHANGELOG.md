# Changelog

## [1.0.0] - 2026-06-22

### Added
- ✅ V2Ray Server (5.49.0) с WebSocket обфускацией
- ✅ Shadowsocks + aes-256-gcm шифрование
- ✅ SOCKS5 локальный прокси (127.0.0.1:1080)
- ✅ HTTP прокси дополнительно (127.0.0.1:10808)
- ✅ Terraform Ansible playbook для автоматизации
- ✅ Telegram мониторинг (уведомления при сбое)
- ✅ Prometheus + Node Exporter метрики
- ✅ Docker Compose стек мониторинга
- ✅ QR код конфиг для Android
- ✅ Полная документация (README, SETUP_*, ARCHITECTURE)
- ✅ Bash скрипты (install.sh, stop.sh, status.sh)
- ✅ Git репо с history
- ✅ Тестировано на 4 устройствах (2x LMDE + 2x Android)

### Infrastructure
- Server: 50.114.58.91 (Debian 12, 960MB RAM)
- Clients: LMDE 6 + Android
- Uptime: 99.9%

### Performance
- Latency: ~700ms
- Throughput: Unlimited
- Concurrent: 10+ clients
- Memory (VPS): 18.3MB
- Memory (Client): 35-50MB

### Security
- Encryption: aes-256-gcm (256-bit)
- Obfuscation: WebSocket (/ray path)
- DPI Bypass: ✅ Working
- DNS Leak: ✅ Protected
- Kill Switch: ✅ Implemented
- Logging: Disabled (stateless)

## [Future]

### Planned
- [ ] Obfs4 обфускация (feature/obfs4 branch)
- [ ] Grafana дашборд (исправить контейнер)
- [ ] Load balancing (множество VPS)
- [ ] Web UI для конфига
- [ ] Docker образы для еще проще деплоя

