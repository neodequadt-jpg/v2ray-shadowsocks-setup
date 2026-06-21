#!/bin/bash
set -e

echo "════════════════════════════════════════════════════"
echo "  V2Ray Installation Script"
echo "════════════════════════════════════════════════════"

# Проверяем ОС
if ! grep -q "Debian\|LMDE" /etc/os-release; then
    echo "❌ Этот скрипт для Debian/LMDE"
    exit 1
fi

# Проверяем что V2Ray бинарник есть
if [ ! -f "v2ray" ]; then
    echo "❌ v2ray бинарник не найден в текущей папке"
    exit 1
fi

echo ""
echo "✅ Проверки пройдены"
echo ""
echo "Запускаю V2Ray..."

# Убиваем старый процесс если есть
pkill -f "v2ray run" 2>/dev/null || true
sleep 2

# Запускаем новый
./v2ray run -config config.json &
V2RAY_PID=$!

sleep 3

# Проверяем что работает
if curl -s --socks5 127.0.0.1:1080 https://api.ipify.org | grep -q "50.114.58.91"; then
    echo "✅ V2Ray успешно запущен!"
    echo "   PID: $V2RAY_PID"
    echo "   SOCKS5: 127.0.0.1:1080"
    echo "   HTTP: 127.0.0.1:10808"
    echo ""
    echo "Тестирование:"
    curl -s --socks5 127.0.0.1:1080 https://api.ipify.org
else
    echo "❌ Ошибка подключения к VPS"
    kill $V2RAY_PID 2>/dev/null || true
    exit 1
fi

