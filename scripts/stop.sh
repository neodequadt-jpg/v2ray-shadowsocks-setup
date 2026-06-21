#!/bin/bash
echo "Останавливаю V2Ray..."
pkill -f "v2ray run" && echo "✅ V2Ray остановлен" || echo "⚠️  V2Ray не запущен"
