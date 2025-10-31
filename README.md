# API de Autenticación - Flask + PostgreSQL

API RESTful profesional de autenticación con Flask, PostgreSQL, bcrypt y Flask-Login. Lista para desplegar en Render.

## 🚀 Características

- ✅ **Autenticación completa**: Registro, login, logout y perfil de usuario
- ✅ **Seguridad**: Contraseñas hasheadas con bcrypt
- ✅ **Base de datos**: PostgreSQL con SQLAlchemy
- ✅ **Sesiones**: Manejo de sesiones con Flask-Login
- ✅ **CORS**: Habilitado para consumo desde apps web y móviles
- ✅ **Validaciones**: Validación robusta de datos de entrada
- ✅ **Manejo de errores**: Respuestas JSON consistentes
- ✅ **Estructura modular**: Código organizado y mantenible
- ✅ **Listo para producción**: Configurado para Render con Gunicorn

## 📁 Estructura del Proyecto

```
.
├── app.py                  # Archivo principal de la aplicación
├── config.py              # Configuración de la app y base de datos
├── requirements.txt       # Dependencias de Python
├── Procfile              # Configuración para Render
├── .env.example          # Ejemplo de variables de entorno
├── models/
│   ├── __init__.py
│   └── user.py           # Modelo de usuario (SQLAlchemy)
├── routes/
│   ├── __init__.py
│   └── auth_routes.py    # Rutas de autenticación
└── utils/
    ├── __init__.py
    └── auth_helpers.py   # Funciones auxiliares (hash, validaciones)
```

## 🛠️ Instalación Local

### Prerequisitos
- Python 3.11+
- PostgreSQL instalado y corriendo

### Pasos

1. **Clonar el repositorio**
```bash
git clone <tu-repositorio>
cd <nombre-del-proyecto>
```

2. **Crear entorno virtual**
```bash
python -m venv venv
source venv/bin/activate  # En Windows: venv\Scripts\activate
```

3. **Instalar dependencias**
```bash
pip install -r requirements.txt
```

4. **Configurar variables de entorno**
```bash
cp .env.example .env
```

Edita `.env` con tus valores:
```env
SECRET_KEY=tu-secret-key-super-segura
DATABASE_URL=postgresql://usuario:contraseña@localhost:5432/auth_db
ENVIRONMENT=development
CORS_ORIGINS=http://localhost:3000
```

5. **Crear base de datos PostgreSQL**
```bash
# Conectarse a PostgreSQL
psql -U postgres

# Crear base de datos
CREATE DATABASE auth_db;
\q
```

6. **Ejecutar la aplicación**
```bash
python app.py
```

La API estará disponible en `http://localhost:5000`

## 📡 Endpoints de la API

### 🏠 Información de la API
```http
GET /
```

Respuesta:
```json
{
  "message": "API de Autenticación - Flask + PostgreSQL",
  "version": "1.0.0",
  "endpoints": {...}
}
```

### 📝 Registrar Usuario
```http
POST /register
Content-Type: application/json

{
  "username": "usuario123",
  "password": "contraseña123"
}
```

**Respuesta exitosa (201):**
```json
{
  "message": "Usuario registrado exitosamente",
  "user": {
    "id": 1,
    "username": "usuario123",
    "role": "user",
    "created_at": "2025-10-31T10:30:00"
  }
}
```

**Nota de seguridad:** Todos los usuarios se registran con rol `"user"` por defecto. El campo `role` no se acepta en el registro para prevenir escalada de privilegios. Para asignar roles administrativos, implementa un proceso de administración separado.

**Errores posibles:**
- `400` - Datos inválidos o faltantes
- `409` - Usuario ya existe
- `500` - Error del servidor

### 🔐 Iniciar Sesión
```http
POST /login
Content-Type: application/json

{
  "username": "usuario123",
  "password": "contraseña123"
}
```

**Respuesta exitosa (200):**
```json
{
  "message": "Inicio de sesión exitoso",
  "user": {
    "id": 1,
    "username": "usuario123",
    "role": "user",
    "created_at": "2025-10-31T10:30:00"
  }
}
```

**Errores posibles:**
- `400` - Datos faltantes
- `401` - Credenciales incorrectas
- `500` - Error del servidor

### 🚪 Cerrar Sesión
```http
GET /logout
```
o
```http
POST /logout
```

**Requiere autenticación** (cookie de sesión)

**Respuesta exitosa (200):**
```json
{
  "message": "Sesión cerrada exitosamente"
}
```

### 👤 Obtener Perfil
```http
GET /perfil
```

**Requiere autenticación** (cookie de sesión)

**Respuesta exitosa (200):**
```json
{
  "user": {
    "id": 1,
    "username": "usuario123",
    "role": "user",
    "created_at": "2025-10-31T10:30:00"
  }
}
```

### 🔑 Verificar API Key (Opcional)
```http
GET /check_api_key
X-API-Key: demo-api-key-12345
```

**Respuesta exitosa (200):**
```json
{
  "message": "API Key válida",
  "valid": true
}
```

**Nota:** Este endpoint es un ejemplo básico. Para producción, implementa un sistema completo de generación y gestión de API keys.

## 🌐 Despliegue en Render

### 1. Preparar el Repositorio

Asegúrate de que todos los archivos estén en tu repositorio de GitHub:
- `app.py`
- `config.py`
- `requirements.txt`
- `Procfile`
- Todo el código fuente

### 2. Crear Web Service en Render

1. Ve a [Render Dashboard](https://dashboard.render.com/)
2. Click en **"New +"** → **"Web Service"**
3. Conecta tu repositorio de GitHub
4. Configura el servicio:

**Settings:**
- **Name**: `api-autenticacion` (o el nombre que prefieras)
- **Environment**: `Python 3`
- **Build Command**: `pip install -r requirements.txt`
- **Start Command**: `gunicorn app:app` (ya está en Procfile)

### 3. Configurar Base de Datos PostgreSQL

1. En Render, ve a **"New +"** → **"PostgreSQL"**
2. Crea una base de datos PostgreSQL
3. Copia la **Internal Database URL**

### 4. Configurar Variables de Entorno

En tu Web Service de Render, ve a **"Environment"** y agrega:

```
SECRET_KEY=<genera-una-key-aleatoria-segura>
DATABASE_URL=<tu-internal-database-url-de-render>
ENVIRONMENT=production
CORS_ORIGINS=https://tu-app-frontend.com,https://www.tu-app-frontend.com,https://app.tudominio.com
```

**⚠️ IMPORTANTE - Configuración de CORS:**
- **NUNCA uses `*` como CORS_ORIGINS en producción**
- El valor `*` NO funciona con cookies de sesión (credentials) en navegadores modernos
- Especifica **todos** los dominios desde donde se consumirá la API, separados por comas
- Incluye tanto `https://dominio.com` como `https://www.dominio.com` si es necesario
- Ejemplos válidos:
  - `CORS_ORIGINS=https://mi-app.com,https://www.mi-app.com`
  - `CORS_ORIGINS=https://app.produccion.com,https://app-staging.produccion.com`

**Generar SECRET_KEY segura:**
```bash
python -c "import secrets; print(secrets.token_hex(32))"
```

### 5. Deploy

Click en **"Create Web Service"** o **"Manual Deploy"**

Render automáticamente:
1. Instalará las dependencias
2. Ejecutará Gunicorn
3. Tu API estará disponible en `https://tu-app.onrender.com`

### 6. Verificar

Visita `https://tu-app.onrender.com/` para verificar que la API esté funcionando.

## 🧪 Ejemplos de Uso

### Con cURL

**Registrar usuario:**
```bash
curl -X POST https://tu-app.onrender.com/register \
  -H "Content-Type: application/json" \
  -d '{"username":"testuser","password":"test123"}'
```

**Iniciar sesión:**
```bash
curl -X POST https://tu-app.onrender.com/login \
  -H "Content-Type: application/json" \
  -d '{"username":"testuser","password":"test123"}' \
  -c cookies.txt
```

**Obtener perfil (con cookie de sesión):**
```bash
curl -X GET https://tu-app.onrender.com/perfil \
  -b cookies.txt
```

### Con JavaScript (Fetch)

```javascript
// Registrar usuario
const register = async () => {
  const response = await fetch('https://tu-app.onrender.com/register', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({
      username: 'testuser',
      password: 'test123'
    })
  });
  const data = await response.json();
  console.log(data);
};

// Iniciar sesión
const login = async () => {
  const response = await fetch('https://tu-app.onrender.com/login', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
    },
    credentials: 'include', // Importante para cookies
    body: JSON.stringify({
      username: 'testuser',
      password: 'test123'
    })
  });
  const data = await response.json();
  console.log(data);
};

// Obtener perfil
const getPerfil = async () => {
  const response = await fetch('https://tu-app.onrender.com/perfil', {
    credentials: 'include' // Importante para enviar cookies
  });
  const data = await response.json();
  console.log(data);
};
```

### Con Python (requests)

```python
import requests

BASE_URL = "https://tu-app.onrender.com"

# Crear sesión para mantener cookies
session = requests.Session()

# Registrar usuario
response = session.post(f"{BASE_URL}/register", json={
    "username": "testuser",
    "password": "test123"
})
print(response.json())

# Iniciar sesión
response = session.post(f"{BASE_URL}/login", json={
    "username": "testuser",
    "password": "test123"
})
print(response.json())

# Obtener perfil (cookie de sesión se envía automáticamente)
response = session.get(f"{BASE_URL}/perfil")
print(response.json())
```

## 🔒 Seguridad

### Mejoras Recomendadas para Producción

1. **SECRET_KEY**: Usa una key aleatoria y segura, nunca uses valores por defecto
2. **HTTPS**: Siempre usa HTTPS en producción (Render lo incluye gratis)
3. **Rate Limiting**: Implementa rate limiting para prevenir ataques de fuerza bruta
4. **Validación de contraseñas**: Considera requisitos más estrictos (mayúsculas, números, símbolos)
5. **Tokens JWT**: Para apps móviles, considera usar JWT en lugar de sesiones
6. **API Keys**: Implementa un sistema completo de gestión de API keys si lo necesitas
7. **Logs y monitoreo**: Implementa logging para auditoría de seguridad

## 📝 Base de Datos

### Modelo User

```python
{
  "id": Integer,           # Primary Key
  "username": String(80),  # Único, indexado
  "password_hash": String(255),  # Nunca se expone en API
  "role": String(20),      # Por defecto "user"
  "created_at": DateTime   # Timestamp de creación
}
```

### Migraciones

Este proyecto usa `db.create_all()` para crear tablas automáticamente. Para proyectos más grandes, considera usar **Flask-Migrate** (Alembic) para gestionar migraciones.

## 🤝 Contribuciones

Si quieres mejorar este proyecto:
1. Fork el repositorio
2. Crea una rama para tu feature (`git checkout -b feature/nueva-funcionalidad`)
3. Commit tus cambios (`git commit -m 'Agregar nueva funcionalidad'`)
4. Push a la rama (`git push origin feature/nueva-funcionalidad`)
5. Abre un Pull Request

## 📄 Licencia

Este proyecto es de código abierto. Úsalo libremente para tus proyectos.

## 💡 Soporte

Si tienes problemas o preguntas:
1. Revisa la sección de errores comunes
2. Verifica que todas las variables de entorno estén configuradas
3. Revisa los logs de Render para errores específicos

---

**¡Listo para producción!** 🚀
