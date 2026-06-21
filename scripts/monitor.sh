#!/bin/bash

case "$1" in
  status)
    echo "📊 VPS Status:"
    ssh root@50.114.58.91 "check-all.sh"
    ;;
  logs)
    echo "📋 VPS Logs:"
    ssh root@50.114.58.91 "show-logs.sh"
    ;;
  restart)
    echo "🔄 Restarting VPS services..."
    ssh root@50.114.58.91 "restart-monitoring.sh"
    ;;
  tunnel)
    echo "🔗 Opening SSH tunnels..."
    echo "  Prometheus: http://localhost:9090"
    echo "  Grafana: http://localhost:3000"
    ssh -L 9090:localhost:9090 -L 3000:localhost:3000 root@50.114.58.91 -N
    ;;
  *)
    echo "Usage: ./scripts/monitor.sh {status|logs|restart|tunnel}"
    echo ""
    echo "  status  - Check VPS monitoring status"
    echo "  logs    - Show VPS logs"
    echo "  restart - Restart all VPS services"
    echo "  tunnel  - SSH tunnels (Prometheus + Grafana)"
    ;;
esac
