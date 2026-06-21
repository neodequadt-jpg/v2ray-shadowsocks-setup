# Настройка V2Ray на Android

## Способ 1: QR код (рекомендуется)

1. **Скачиваешь Shadowsocks**
   - Google Play → Shadowsocks

2. **Запускаешь приложение**

3. **Сканируешь QR**
   - Нажимаешь (+)
   - Выбираешь "Scan QR Code"
   - Наводишь на `android_shadowsocks.png`

4. **Подключаешься**
   - Выбираешь профиль
   - Нажимаешь зелёную кнопку "Connect"
   - Ждёшь 3-5 секунд

5. **Проверяешь**
   - Открываешь браузер
   - Идёшь на https://api.ipify.org
   - Должно показать: 50.114.58.91 ✓

## Способ 2: Вручную

Если QR сканирование не работает:

1. Shadowsocks → (+) Add Profile
2. Заполняешь:
   - **Server Address:** 50.114.58.91
   - **Server Port:** 8388
   - **Password:** 42vGugNC4IFwmxxZswByqQa7bpY986VR
   - **Encryption:** aes-256-gcm
3. Save → Connect

## Troubleshooting

| Проблема | Решение |
|----------|---------|
| "Connection refused" | VPS не работает - проверь на LMDE |
| "Connection timeout" | Интернет блокирует - попробуй другую сеть |
| YouTube не открывается | Перезагрузи приложение (swipe down) |

