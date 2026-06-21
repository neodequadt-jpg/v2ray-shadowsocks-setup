# Настройка V2Ray на LMDE

## Установка

```bash
# Клонируем проект
git clone https://github.com/neodequadt-jpg/v2ray-shadowsocks-setup
cd v2ray-shadowsocks-setup

# Запускаем V2Ray
./v2ray run -config config.json &
```

## Проверка

```bash
# SOCKS5 работает?
curl -s --socks5 127.0.0.1:1080 https://api.ipify.org
# Результат: 50.114.58.91 ✓

# HTTP прокси работает?
curl -s -x http://127.0.0.1:10808 https://api.ipify.org
# Результат: 50.114.58.91 ✓
```

## Firefox

1. Preferences → Network → Settings
2. Manual proxy configuration
3. SOCKS Host: 127.0.0.1, Port: 1080, SOCKS v5
4. Apply
5. Открыть YouTube → должно работать ✓

## proxychains

```bash
proxychains firefox &
proxychains curl https://example.com
```

## Автозапуск (опционально)

```bash
# Добавить в ~/.bashrc
alias v2ray-start="cd ~/v2ray-shadowsocks-setup && ./v2ray run -config config.json &"
```

