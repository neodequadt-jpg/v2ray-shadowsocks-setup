#!/usr/bin/env python3

from flask import Flask, render_template, jsonify
import subprocess
import time
from datetime import datetime

app = Flask(__name__)
start_time = time.time()

def get_v2ray_status():
    try:
        # Проверяем запущен ли V2Ray
        result = subprocess.run(['pgrep', '-f', 'v2ray run'], 
                              capture_output=True, text=True)
        running = bool(result.stdout.strip())
        
        # Получаем память V2Ray
        memory_mb = 0
        cpu = 0
        if running:
            try:
                result = subprocess.run(['ps', 'aux'], 
                                      capture_output=True, text=True)
                for line in result.stdout.split('\n'):
                    if 'v2ray' in line and 'grep' not in line:
                        parts = line.split()
                        if len(parts) > 5:
                            memory_mb = round(int(parts[5]) / 1024, 2)
                            cpu = float(parts[2])
            except:
                pass
        
        # Считаем соединения
        connections = 0
        try:
            result = subprocess.run(['ss', '-tan'], 
                                  capture_output=True, text=True)
            connections = result.stdout.count('ESTAB')
        except:
            pass
        
        return {
            'running': running,
            'memory_mb': memory_mb,
            'cpu': cpu,
            'connections': connections
        }
    except Exception as e:
        print(f"Error: {e}")
        return {'running': False, 'memory_mb': 0, 'cpu': 0, 'connections': 0}

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/api/status')
def api_status():
    status = get_v2ray_status()
    uptime = int(time.time() - start_time)
    
    return jsonify({
        'v2ray': status,
        'uptime': uptime,
        'timestamp': datetime.now().isoformat()
    })

if __name__ == '__main__':
    print("🚀 V2Ray Dashboard запущен на http://127.0.0.1:5000")
    app.run(host='0.0.0.0', port=5000, debug=False, threaded=True)

