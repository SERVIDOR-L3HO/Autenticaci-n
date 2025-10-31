# API de Autenticación Flask + PostgreSQL

## Descripción General
API RESTful profesional de autenticación construida con Flask, PostgreSQL, bcrypt y Flask-Login. Lista para desplegar en Render.

**Fecha de creación:** 31 de Octubre, 2025  
**Estado:** Producción - Lista para desplegar  
**Tecnologías principales:** Python 3.11, Flask 3.0, PostgreSQL, SQLAlchemy, bcrypt, Flask-Login

## Características Principales
- ✅ Sistema de autenticación completo (registro, login, logout, perfil)
- ✅ Seguridad robusta con contraseñas hasheadas (bcrypt)
- ✅ Base de datos PostgreSQL con SQLAlchemy ORM
- ✅ Protección contra escalada de privilegios (roles asignados en servidor)
- ✅ CORS configurado apropiadamente para producción
- ✅ Validación de datos de entrada
- ✅ Manejo consistente de errores con respuestas JSON
- ✅ Listo para Render con Gunicorn

## Estructura del Proyecto

```
.
├── app.py                     # Aplicación Flask principal
├── config.py                  # Configuración (DB, CORS, SECRET_KEY)
├── requirements.txt           # Dependencias Python
├── Procfile                   # Configuración Render/Gunicorn
├── .env.example              # Ejemplo variables de entorno
├── .gitignore                # Archivos ignorados por git
├── README.md                 # Documentación completa
├── models/
│   ├── __init__.py
│   └── user.py               # Modelo User (SQLAlchemy)
├── routes/
│   ├── __init__.py
│   └── auth_routes.py        # Rutas: /register, /login, /logout, /perfil, /check_api_key
└── utils/
    ├── __init__.py
    └── auth_helpers.py       # Hash bcrypt, validaciones
```

## Endpoints Disponibles

| Método | Ruta | Descripción | Auth Requerida |
|--------|------|-------------|----------------|
| GET | / | Información de la API | No |
| POST | /register | Registrar nuevo usuario | No |
| POST | /login | Iniciar sesión | No |
| GET/POST | /logout | Cerrar sesión | Sí |
| GET | /perfil | Obtener datos del usuario | Sí |
| GET | /check_api_key | Verificar API Key (DEMO) | No |

## Configuración Importante

### Variables de Entorno Requeridas
- `SECRET_KEY`: Clave secreta para Flask (generar con `secrets.token_hex(32)`)
- `DATABASE_URL`: URL de conexión PostgreSQL
- `ENVIRONMENT`: `development` o `production`
- `CORS_ORIGINS`: Orígenes permitidos (separados por coma)

### Configuración de CORS (CRÍTICO)
⚠️ **NUNCA usar `*` en producción con cookies de sesión**
- En desarrollo: CORS_ORIGINS=`*` funciona sin credentials
- En producción: Especificar orígenes explícitos (ej: `https://app.com,https://www.app.com`)
- La app emite advertencias en stderr si se detecta `*` en producción

### Seguridad Implementada
1. **Contraseñas**: Hasheadas con bcrypt (nunca almacenadas en texto plano)
2. **Roles**: Asignados en servidor (no controlados por cliente) - previene escalada de privilegios
3. **Sesiones**: Manejadas con Flask-Login + cookies HttpOnly
4. **Validaciones**: Username (3-30 chars, alfanumérico), Password (mínimo 6 chars)
5. **CORS**: Configurado correctamente para evitar problemas con credentials

## Cambios Recientes

### 2025-10-31 - Correcciones de Seguridad
- **CRÍTICO**: Eliminado campo `role` del endpoint `/register` para prevenir escalada de privilegios
- **CORS**: Agregada lógica para manejar `*` vs orígenes explícitos con advertencias runtime
- **Documentación**: Añadidas advertencias claras sobre CORS en README.md y .env.example
- **API Key Demo**: Mejoradas advertencias en `/check_api_key` - solo para demostración

### 2025-10-31 - Implementación Inicial
- Estructura modular profesional creada
- Modelo User con SQLAlchemy + PostgreSQL
- Rutas de autenticación completas
- Sistema de hash con bcrypt
- Configuración CORS con Flask-CORS
- README completo con instrucciones de despliegue

## Workflow Configurado
- **Nombre:** Flask API Server
- **Comando:** `python app.py`
- **Puerto:** 5000 (webview)
- **Estado:** ✅ Corriendo sin errores

## Despliegue en Render

### Pasos Rápidos
1. Subir código a GitHub
2. Crear PostgreSQL Database en Render
3. Crear Web Service vinculado al repo
4. Configurar variables de entorno:
   - SECRET_KEY (generada aleatoria)
   - DATABASE_URL (Internal URL de Render)
   - ENVIRONMENT=production
   - CORS_ORIGINS (dominios específicos, no `*`)
5. Deploy automático

### Comandos de Render
- **Build:** `pip install -r requirements.txt`
- **Start:** `gunicorn app:app` (definido en Procfile)

## Dependencias Principales
- Flask 3.0.0
- Flask-SQLAlchemy 3.1.1
- Flask-Login 0.6.3
- Flask-CORS 4.0.0
- psycopg2-binary 2.9.9
- bcrypt 4.1.2
- gunicorn 21.2.0 (producción)

## Testing
La API está funcionando correctamente:
- ✅ Base de datos PostgreSQL conectada
- ✅ Servidor corriendo en 0.0.0.0:5000
- ✅ Endpoints respondiendo con JSON
- ✅ Sin errores en logs

## Notas de Desarrollo

### Preferencias del Usuario
- Proyecto completamente en español (código y documentación)
- Orientado a producción en Render
- Enfoque en seguridad y mejores prácticas
- Código comentado y documentado

### Mejoras Futuras Sugeridas
1. Implementar JWT para autenticación stateless (mejor para apps móviles)
2. Sistema real de API Keys con base de datos y rotación
3. Rate limiting para prevenir ataques de fuerza bruta
4. Migraciones de base de datos con Flask-Migrate/Alembic
5. Tests unitarios y de integración
6. Logging estructurado para auditoría
7. Validaciones de contraseña más estrictas (mayúsculas, números, símbolos)
8. Sistema de recuperación de contraseña vía email
9. Endpoints CRUD para gestión de roles (solo admin)
10. Documentación automática de API con Swagger/OpenAPI

## Información Técnica

### Base de Datos
**Tabla:** `users`
- `id` (Integer, PK, Auto-increment)
- `username` (String 80, Unique, Indexed)
- `password_hash` (String 255)
- `role` (String 20, Default: 'user')
- `created_at` (DateTime, Default: UTC now)

### Flujo de Autenticación
1. **Registro:** POST /register → Validar → Hash bcrypt → Guardar en DB
2. **Login:** POST /login → Verificar usuario → Verificar bcrypt → Crear sesión Flask-Login
3. **Acceso protegido:** GET /perfil → Verificar sesión → Retornar datos usuario
4. **Logout:** POST /logout → Destruir sesión

## Revisión de Arquitecto
✅ **APROBADO PARA PRODUCCIÓN** (31 Oct 2025)
- Todos los problemas críticos de seguridad resueltos
- Documentación completa y clara
- Código listo para GitHub y Render
- Sin problemas de seguridad identificados

---
**Última actualización:** 31 de Octubre, 2025
