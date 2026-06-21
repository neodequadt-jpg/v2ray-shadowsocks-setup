#!/bin/bash
echo "════════════════════════════════════════════════════"
echo "  V2Ray Status"
echo "════════════════════════════════════════════════════"

if pgrep -f "v2ray run" > /dev/null; then
    echo "✅ V2Ray: RUNNING"
    
    if timeout 2 curl -s --socks5 127.0.0.1:1080 https://api.ipify.org > /dev/null; then
        echo "✅ SOCKS5: OK"
        echo ""
        echo "IP: $(curl -s --socks5 127.0.0.1:1080 https://api.ipify.org)"
    else
        echo "❌ SOCKS5: TIMEOUT"
    fi
else
    echo "❌ V2Ray: NOT RUNNING"
fi

echo ""
echo "Ports:"
ss -tulpn | grep -E "1080|10808"

