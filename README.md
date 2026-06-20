# V2RAY + SHADOWSOCKS VPN - РАБОЧЕЕ РЕШЕНИЕ

## ✅ ЧТО РАБОТАЕТ

- VPS: 50.114.58.91:8388
- Шифрование: aes-256-gcm
- Обфускация: WebSocket (/ray)
- Статус: PRODUCTION READY
- Все тесты: PASSED ✓

## 📝 CREDENTIALS
Server: 50.114.58.91

Port: 8388

Password: 42vGugNC4IFwmxxZswByqQa7bpY986VR

Method: aes-256-gcm

## 🚀 ИСПОЛЬЗОВАНИЕ

### Linux (LMDE)
```bash
cd v2ray_local
./v2ray run -config config.json &
curl --socks5 127.0.0.1:1080 https://api.ipify.org
# Должен быть: 50.114.58.91
```

### Firefox
Preferences → Network → Manual proxy
- SOCKS Host: 127.0.0.1
- Port: 1080
- SOCKS v5

### Android
Google Play → V2RayNG
Import JSON конфиг из папки

## 📊 СТАТИСТИКА

- IP: 50.114.58.91 ✓
- Скорость: ~700ms ✓
- Обход DPI: WebSocket ✓
- Все ОС: Поддерживаются ✓

