# 📱 Guía de Instalación en Termux (Android)

Esta guía te ayudará a instalar y ejecutar la API de autenticación Flask en tu dispositivo Android usando Termux.

## 📋 Requisitos Previos

1. **Termux instalado**
   - ⚠️ **NO uses la versión de Play Store** (está desactualizada)
   - Descarga desde [F-Droid](https://f-droid.org/packages/com.termux/) (recomendado)
   - O desde [GitHub Releases](https://github.com/termux/termux-app/releases)

2. **Conexión a Internet** estable

3. **Al menos 500 MB de espacio libre**

---

## 🚀 Instalación Automática (Recomendado)

### Opción 1: Script Completo de Instalación

Este script instala TODO automáticamente: Python, PostgreSQL, dependencias y te muestra tu IP pública.

```bash
# 1. Abre Termux y navega a la carpeta del proyecto
cd /ruta/donde/está/el/proyecto

# 2. Da permisos de ejecución al script
chmod +x install_termux.sh

# 3. Ejecuta el instalador
./install_termux.sh
```

El script hará automáticamente:
- ✅ Actualizar paquetes de Termux
- ✅ Instalar Python 3
- ✅ Instalar PostgreSQL
- ✅ Instalar todas las dependencias (Flask, bcrypt, etc.)
- ✅ Configurar la base de datos
- ✅ Crear variables de entorno
- ✅ Mostrar tu IP pública y local
- ✅ Darte opción de iniciar la API inmediatamente

**Tiempo estimado:** 5-10 minutos (dependiendo de tu conexión)

---

### Opción 2: Solo Mostrar IP Pública

Si ya tienes todo instalado y solo quieres ver tu IP:

```bash
# Da permisos
chmod +x show_ip.sh

# Ejecuta
./show_ip.sh
```

Esto te mostrará:
- 🌐 Tu IP Pública
- 📱 Tu IP Local (WiFi)
- 🔗 URLs de acceso para tu API

---

## 🛠️ Instalación Manual (Paso a Paso)

Si prefieres hacerlo manualmente:

### 1. Actualizar Termux
```bash
pkg update && pkg upgrade
```

### 2. Instalar Python
```bash
pkg install python
```

### 3. Instalar PostgreSQL
```bash
pkg install postgresql
```

### 4. Inicializar PostgreSQL
```bash
initdb $PREFIX/var/lib/postgresql
pg_ctl -D $PREFIX/var/lib/postgresql start
```

### 5. Crear base de datos
```bash
createdb auth_db
```

### 6. Instalar dependencias de Python
```bash
pip install --upgrade pip
pip install Flask==3.0.0
pip install Flask-SQLAlchemy==3.1.1
pip install Flask-Login==0.6.3
pip install Flask-CORS==4.0.0
pip install psycopg2-binary==2.9.9
pip install bcrypt==4.1.2
pip install python-dotenv==1.0.0
```

### 7. Configurar variables de entorno
```bash
cat > .env << EOF
SECRET_KEY=$(python -c "import secrets; print(secrets.token_hex(32))")
DATABASE_URL=postgresql://localhost/auth_db
ENVIRONMENT=development
CORS_ORIGINS=*
PORT=5000
EOF
```

### 8. Iniciar la API
```bash
python app.py
```

---

## 🌐 Acceder a tu API

### Desde el mismo dispositivo (Termux)
```
http://localhost:5000
```

### Desde otros dispositivos en tu WiFi
```
http://TU_IP_LOCAL:5000
```

Para obtener tu IP local:
```bash
ifconfig | grep inet
```

### Desde Internet (requiere configuración adicional)
```
http://TU_IP_PUBLICA:5000
```

Para obtener tu IP pública:
```bash
curl ifconfig.me
```

⚠️ **IMPORTANTE:** Para acceso desde internet, necesitas configurar **Port Forwarding** en tu router:
- Puerto externo: 5000
- Puerto interno: 5000
- IP destino: Tu IP local del teléfono

---

## 🔧 Comandos Útiles

Después de ejecutar el script de instalación, tendrás estos alias disponibles:

```bash
# PostgreSQL
pgstart      # Iniciar servidor PostgreSQL
pgstop       # Detener servidor PostgreSQL
pgstatus     # Ver estado del servidor

# API
apistart     # Iniciar la API (python app.py)

# Red
myip         # Ver tu IP pública
```

Para usar estos comandos, primero ejecuta:
```bash
source ~/.bashrc
```

---

## 📝 Mantener PostgreSQL Corriendo

PostgreSQL debe estar corriendo antes de iniciar la API. Si cierras Termux:

1. **Al volver a abrir Termux:**
```bash
pgstart    # o: pg_ctl -D $PREFIX/var/lib/postgresql start
```

2. **Luego inicia la API:**
```bash
python app.py
```

---

## 🐛 Solución de Problemas

### Error: "psycopg2 no se puede instalar"
```bash
pkg install postgresql-contrib
pip install psycopg2-binary
```

### Error: "Repository is under maintenance"
```bash
termux-change-repo
# Selecciona mirrors alternativos
```

### PostgreSQL no inicia
```bash
# Verificar si ya está corriendo
pg_ctl -D $PREFIX/var/lib/postgresql status

# Si está corriendo pero da error, reiniciar
pg_ctl -D $PREFIX/var/lib/postgresql restart
```

### La API no es accesible desde otros dispositivos
1. Verifica que tu teléfono y el otro dispositivo estén en la misma red WiFi
2. Verifica el firewall de tu router
3. Asegúrate de usar la IP local correcta (ejecuta `ifconfig`)

### Termux se cierra al bloquear el teléfono
Para evitar que Termux se cierre:
1. Activa la notificación persistente de Termux
2. O usa `termux-wake-lock` antes de ejecutar la API

---

## 🔒 Seguridad en Termux

⚠️ **Consideraciones importantes:**

1. **No expongas la API directamente a Internet sin protección**
   - Usa un proxy inverso (nginx)
   - Configura HTTPS con certificados SSL
   - Implementa rate limiting

2. **Cambia la SECRET_KEY**
   ```bash
   python -c "import secrets; print(secrets.token_hex(32))"
   ```

3. **Configura CORS apropiadamente**
   - No uses `*` en producción
   - Especifica dominios permitidos

---

## 📊 Verificar que Todo Funciona

### 1. Verificar PostgreSQL
```bash
psql auth_db -c "SELECT version();"
```

### 2. Verificar la API
```bash
curl http://localhost:5000/
```

Deberías ver un JSON con información de la API.

### 3. Registrar un usuario de prueba
```bash
curl -X POST http://localhost:5000/register \
  -H "Content-Type: application/json" \
  -d '{"username":"test","password":"test123"}'
```

---

## 💡 Consejos Adicionales

### Permitir acceso al almacenamiento
Para guardar logs o archivos fuera de Termux:
```bash
termux-setup-storage
```

### Instalar Git (para actualizar el proyecto)
```bash
pkg install git
```

### Crear un entorno virtual (opcional pero recomendado)
```bash
pip install virtualenv
virtualenv venv
source venv/bin/activate
pip install -r requirements.txt
```

---

## 📱 Mantener la API Corriendo en Segundo Plano

### Opción 1: tmux (recomendado)
```bash
# Instalar tmux
pkg install tmux

# Crear sesión
tmux new -s api

# Iniciar API
python app.py

# Desconectar (Ctrl+B, luego D)

# Reconectar más tarde
tmux attach -t api
```

### Opción 2: nohup
```bash
nohup python app.py > api.log 2>&1 &
```

Para detener:
```bash
pkill -f "python app.py"
```

---

## 🎯 Siguientes Pasos

Una vez que tengas la API corriendo:

1. **Prueba los endpoints** con Postman o curl
2. **Conecta tu frontend** (React, Vue, etc.)
3. **Configura HTTPS** si vas a exponer públicamente
4. **Considera desplegar en Render** para producción (ver README.md principal)

---

## 🆘 Ayuda

Si tienes problemas:
1. Revisa los logs: `cat api.log` o los errores en pantalla
2. Verifica que PostgreSQL esté corriendo: `pgstatus`
3. Verifica tu conexión: `ping google.com`
4. Consulta la documentación de Termux: https://wiki.termux.com

---

**¡Listo! Tu API de autenticación Flask ahora corre en tu Android.** 🚀
