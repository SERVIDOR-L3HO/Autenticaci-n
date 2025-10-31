"""
Archivo principal de la aplicación Flask
API de autenticación con PostgreSQL

Este archivo inicializa la aplicación Flask, configura la base de datos,
CORS, Flask-Login, y registra las rutas de autenticación.
"""
import os
from flask import Flask, jsonify
from flask_cors import CORS
from flask_login import LoginManager
from config import Config
from models.user import db, User
from routes.auth_routes import auth_bp

def create_app(config_class=Config):
    """
    Factory function para crear y configurar la aplicación Flask
    
    Args:
        config_class: Clase de configuración a usar
        
    Returns:
        Aplicación Flask configurada
    """
    # Crear instancia de Flask
    app = Flask(__name__)
    
    # Cargar configuración
    app.config.from_object(config_class)
    
    # Inicializar extensiones
    db.init_app(app)
    
    # Configurar CORS
    # IMPORTANTE: '*' no funciona con credentials=True en navegadores
    # En producción, especifica orígenes explícitos en CORS_ORIGINS
    cors_origins = app.config['CORS_ORIGINS']
    if cors_origins == ['*']:
        # Modo desarrollo: permite todos los orígenes pero sin credentials
        CORS(app, origins='*', supports_credentials=False)
        # Advertencia en producción
        if app.config.get('ENVIRONMENT') == 'production':
            import sys
            print("⚠️  ADVERTENCIA DE SEGURIDAD: CORS_ORIGINS está configurado como '*' en producción.", file=sys.stderr)
            print("⚠️  Las cookies de sesión NO funcionarán con esta configuración.", file=sys.stderr)
            print("⚠️  Configura CORS_ORIGINS con dominios específicos (ej: https://tu-app.com)", file=sys.stderr)
    else:
        # Modo producción: orígenes específicos con credentials habilitadas
        CORS(app, origins=cors_origins, supports_credentials=True)
    
    # Configurar Flask-Login
    login_manager = LoginManager()
    login_manager.init_app(app)
    login_manager.login_view = 'auth.login'
    
    @login_manager.user_loader
    def load_user(user_id):
        """
        Callback requerido por Flask-Login
        Carga un usuario por su ID desde la base de datos
        """
        return User.query.get(int(user_id))
    
    @login_manager.unauthorized_handler
    def unauthorized():
        """
        Maneja intentos de acceso no autorizados
        Retorna JSON en lugar de redirigir (apropiado para API)
        """
        return jsonify({
            'error': 'Autenticación requerida',
            'message': 'Debes iniciar sesión para acceder a este recurso'
        }), 401
    
    # Registrar blueprints (rutas)
    app.register_blueprint(auth_bp)
    
    # Ruta raíz - información de la API
    @app.route('/')
    def index():
        """
        Ruta raíz - Muestra información básica de la API
        """
        return jsonify({
            'message': 'API de Autenticación - Flask + PostgreSQL',
            'version': '1.0.0',
            'endpoints': {
                'POST /register': 'Registrar nuevo usuario',
                'POST /login': 'Iniciar sesión',
                'GET/POST /logout': 'Cerrar sesión (requiere auth)',
                'GET /perfil': 'Obtener perfil de usuario (requiere auth)',
                'GET /check_api_key': 'Verificar API Key (opcional)'
            },
            'documentation': 'Ver README.md para instrucciones de uso'
        }), 200
    
    # Manejo de errores 404
    @app.errorhandler(404)
    def not_found(error):
        """Maneja errores 404 - Ruta no encontrada"""
        return jsonify({
            'error': 'Ruta no encontrada',
            'message': 'El endpoint solicitado no existe'
        }), 404
    
    # Manejo de errores 500
    @app.errorhandler(500)
    def internal_error(error):
        """Maneja errores 500 - Error interno del servidor"""
        db.session.rollback()
        return jsonify({
            'error': 'Error interno del servidor',
            'message': 'Ocurrió un error inesperado'
        }), 500
    
    # Crear tablas en la base de datos (si no existen)
    with app.app_context():
        db.create_all()
        print("✓ Base de datos inicializada correctamente")
    
    return app


# Crear la aplicación
app = create_app()

if __name__ == '__main__':
    # Obtener puerto desde variable de entorno (para Render)
    # o usar 5000 por defecto para desarrollo local
    port = int(os.getenv('PORT', 5000))
    
    # Iniciar servidor
    # En producción, Render usa Gunicorn (ver Procfile)
    # En desarrollo local, usa el servidor de Flask
    app.run(
        host='0.0.0.0',  # Permite conexiones externas
        port=port,
        debug=os.getenv('ENVIRONMENT', 'development') == 'development'
    )
