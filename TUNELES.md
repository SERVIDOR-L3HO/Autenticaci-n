# 🌐 Guía de Túneles - Dominio Público para tu API

Esta guía te muestra cómo convertir tu IP local (`http://192.168.100.15:5000`) en un dominio público amigable como `https://mi-api.loca.lt`.

---

## 🎯 ¿Qué es un Túnel?

Un túnel expone tu servidor local (corriendo en Termux) a Internet con un dominio público. Es como tener tu propia URL sin necesidad de configurar routers o DNS.

**Convierte esto:**
```
http://192.168.100.15:5000
```

**En esto:**
```
https://mi-api-personal.loca.lt
```

---

## 🚀 Opciones Disponibles

Hemos creado 4 scripts para diferentes servicios de túnel:

### 1️⃣ Túnel SSH (localhost.run) - **RECOMENDADO** ⭐

**Script:** `tunnel_ssh.sh`

✅ **Ventajas:**
- ✨ 100% GRATIS sin límites
- ⚡ No requiere instalación (solo SSH)
- 🔒 HTTPS automático
- 🎯 Sin necesidad de cuenta

❌ **Desventajas:**
- URL aleatoria cada vez
- No puedes elegir el nombre

**Uso:**
```bash
chmod +x tunnel_ssh.sh
./tunnel_ssh.sh
```

**Resultado:**
```
Tu API está disponible en:
https://abc123xyz.localhost.run
```

---

### 2️⃣ LocalTunnel - Mejor para Nombres Personalizados

**Script:** `tunnel_localtunnel.sh`

✅ **Ventajas:**
- ✨ GRATIS
- 🎨 Puedes elegir nombre personalizado
- 🔒 HTTPS incluido
- 📱 No requiere cuenta

❌ **Desventajas:**
- Requiere Node.js (se instala automáticamente)
- Nombres populares pueden estar ocupados

**Uso:**
```bash
chmod +x tunnel_localtunnel.sh
./tunnel_localtunnel.sh
```

Te preguntará el nombre que quieres:
```
¿Nombre personalizado? mi-api-auth
Tu API está disponible en:
https://mi-api-auth.loca.lt
```

---

### 3️⃣ ngrok - Más Profesional

**Script:** `tunnel_ngrok.sh`

✅ **Ventajas:**
- 🏆 Más estable y confiable
- 📊 Panel de control web
- 🔧 Muchas opciones avanzadas
- 🌍 Servidores en varios países

❌ **Desventajas:**
- Requiere cuenta gratuita
- Límites en plan gratuito (2 horas por sesión sin cuenta premium)

**Uso:**
```bash
chmod +x tunnel_ngrok.sh
./tunnel_ngrok.sh
```

Primera vez te pedirá registrarte en: https://dashboard.ngrok.com/signup

**Resultado:**
```
Tu API está disponible en:
https://abc123-456.ngrok-free.app
```

---

### 4️⃣ Script Todo-en-Uno - **MÁS FÁCIL** 🎁

**Script:** `start_with_tunnel.sh`

Este script inicia TODO automáticamente:
- ✅ PostgreSQL
- ✅ Tu API Flask
- ✅ Túnel público (tú eliges cuál)

**Uso:**
```bash
chmod +x start_with_tunnel.sh
./start_with_tunnel.sh
```

Te mostrará un menú para elegir el túnel y lo iniciará todo automáticamente. ¡Listo en segundos!

---

## 📋 Comparación Rápida

| Servicio | Gratis | Cuenta | Personalizar Nombre | Estabilidad | Instalación |
|----------|--------|--------|---------------------|-------------|-------------|
| **localhost.run** | ✅ | No | ❌ | ⭐⭐⭐ | Mínima |
| **LocalTunnel** | ✅ | No | ✅ | ⭐⭐⭐ | Node.js |
| **ngrok** | ✅/💰 | Sí | 💰 | ⭐⭐⭐⭐⭐ | Media |

---

## 🛠️ Instalación Rápida

### Dar Permisos a Todos los Scripts:
```bash
chmod +x tunnel_ssh.sh
chmod +x tunnel_localtunnel.sh
chmod +x tunnel_ngrok.sh
chmod +x start_with_tunnel.sh
```

---

## 🎮 Uso Completo - Ejemplo

### Opción A: Manual (Control Total)

**Terminal 1** - Inicia PostgreSQL y API:
```bash
pgstart              # Iniciar PostgreSQL
python app.py        # Iniciar API
```

**Terminal 2** - Inicia el túnel:
```bash
./tunnel_ssh.sh      # O el que prefieras
```

### Opción B: Automático (Más Fácil)

**Una sola terminal:**
```bash
./start_with_tunnel.sh
```

Elige tu túnel favorito y ¡listo!

---

## 🌐 Cómo Compartir tu API

Una vez que el túnel esté activo:

1. **Copia la URL que te da** (ej: `https://abc123.localhost.run`)

2. **Compártela con quien quieras**
   - Por WhatsApp
   - Por email
   - En tu app móvil
   - En Postman

3. **Úsala como cualquier API normal:**

```bash
# Registrar usuario
curl -X POST https://abc123.localhost.run/register \
  -H "Content-Type: application/json" \
  -d '{"username":"test","password":"test123"}'

# Login
curl -X POST https://abc123.localhost.run/login \
  -H "Content-Type: application/json" \
  -d '{"username":"test","password":"test123"}'
```

---

## 🔒 Seguridad

⚠️ **IMPORTANTE:**

1. **Estos túneles exponen tu API a Internet**
   - Cualquiera con la URL puede acceder
   - Usa contraseñas seguras
   - No compartas la URL públicamente

2. **Para producción real:**
   - Despliega en Render (ver README.md)
   - Usa un dominio propio
   - Configura rate limiting

3. **Los túneles son perfectos para:**
   - ✅ Desarrollo y pruebas
   - ✅ Demos rápidos
   - ✅ Compartir con tu equipo
   - ❌ Aplicaciones en producción 24/7

---

## 🐛 Solución de Problemas

### El túnel se cierra inmediatamente
- Verifica que la API esté corriendo en puerto 5000
- Ejecuta primero: `python app.py`
- Luego en otra terminal el túnel

### "Connection refused"
```bash
# Verifica que la API esté corriendo
curl http://localhost:5000/

# Si no responde, revisa los logs
cat api.log
```

### ngrok pide authtoken
1. Crea cuenta gratuita: https://dashboard.ngrok.com/signup
2. Copia tu token
3. Ejecútalo: `ngrok config add-authtoken TU_TOKEN`

### LocalTunnel no inicia
```bash
# Reinstalar
npm uninstall -g localtunnel
npm install -g localtunnel
```

---

## 💡 Tips Profesionales

### 1. Mantener el túnel activo
Si Termux se cierra, el túnel también. Para evitarlo:

```bash
# Opción 1: Usar tmux
pkg install tmux
tmux new -s tunnel
./start_with_tunnel.sh
# Presiona Ctrl+B, luego D para salir sin cerrar

# Opción 2: Usar wake-lock
termux-wake-lock
./start_with_tunnel.sh
```

### 2. URL fija con LocalTunnel
Usa siempre el mismo nombre:
```bash
lt --port 5000 --subdomain mi-api-unica-2025
```

### 3. Múltiples túneles
Puedes tener varios túneles apuntando al mismo servidor:
```bash
# Terminal 1: LocalTunnel
lt --port 5000 --subdomain api-dev

# Terminal 2: ngrok
ngrok http 5000
```

---

## 📊 Monitorear tu Túnel

### Con ngrok:
Visita: `http://127.0.0.1:4040`
- Ve todas las peticiones en tiempo real
- Inspecciona headers y payloads

### Con logs:
```bash
# Ver peticiones en tiempo real
tail -f api.log
```

---

## 🎯 Casos de Uso

### Desarrollo Local
```bash
./tunnel_ssh.sh
# Comparte la URL con tu equipo
```

### Demo para Cliente
```bash
./tunnel_localtunnel.sh
# Nombre: demo-cliente-octubre
# URL: https://demo-cliente-octubre.loca.lt
```

### Testing desde App Móvil
```bash
./start_with_tunnel.sh
# Usa la URL en tu app React Native / Flutter
```

---

## 🆘 Ayuda Rápida

**¿Qué túnel usar?**
- Prueba rápida → `tunnel_ssh.sh`
- Nombre personalizado → `tunnel_localtunnel.sh`
- Producción temporal → `tunnel_ngrok.sh`
- Todo automático → `start_with_tunnel.sh`

**¿Cómo detener?**
- Presiona `Ctrl+C` en la terminal del túnel

**¿La URL caduca?**
- Sí, cuando cierres el túnel
- Con ngrok cuenta paga puedes tener URLs permanentes

---

## 🚀 Próximos Pasos

Una vez que pruebes los túneles y estés listo para producción:

1. **Despliega en Render** (ver README.md principal)
2. **Compra un dominio** personalizado
3. **Configura HTTPS** con Let's Encrypt
4. **Implementa CDN** con Cloudflare

---

**¡Disfruta tu API con dominio público!** 🎉

Tu IP `http://192.168.100.15:5000` ahora es `https://tu-api.loca.lt`
