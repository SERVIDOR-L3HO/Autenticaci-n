"""
Rutas de autenticación
Maneja registro, login, logout y perfil de usuarios
"""
from flask import Blueprint, request, jsonify
from flask_login import login_user, logout_user, login_required, current_user
from models.user import db, User
from utils.auth_helpers import hash_password, verify_password, validate_username, validate_password

# Crear blueprint para rutas de autenticación
auth_bp = Blueprint('auth', __name__)


@auth_bp.route('/register', methods=['POST'])
def register():
    """
    Ruta: POST /register
    Registra un nuevo usuario en el sistema
    
    Body (JSON):
        {
            "username": "usuario123",
            "password": "contraseña"
        }
    
    Returns:
        JSON con mensaje de éxito o error
    
    Nota: Todos los usuarios nuevos se registran con rol 'user' por defecto.
    Para asignar roles especiales (como 'admin'), se requiere un proceso administrativo separado.
    """
    try:
        # Obtener datos del request
        data = request.get_json()
        
        if not data:
            return jsonify({'error': 'No se proporcionaron datos'}), 400
        
        username = data.get('username', '').strip()
        password = data.get('password', '')
        # SEGURIDAD: El rol siempre se asigna como 'user' en el servidor
        # No permitimos que el cliente establezca el rol para prevenir escalada de privilegios
        role = 'user'
        
        # Validar username
        is_valid, error_msg = validate_username(username)
        if not is_valid:
            return jsonify({'error': error_msg}), 400
        
        # Validar password
        is_valid, error_msg = validate_password(password)
        if not is_valid:
            return jsonify({'error': error_msg}), 400
        
        # Verificar que el username no esté duplicado
        existing_user = User.query.filter_by(username=username).first()
        if existing_user:
            return jsonify({'error': 'El nombre de usuario ya está en uso'}), 409
        
        # Crear nuevo usuario
        password_hash = hash_password(password)
        new_user = User(
            username=username,
            password_hash=password_hash,
            role=role
        )
        
        # Guardar en la base de datos
        db.session.add(new_user)
        db.session.commit()
        
        return jsonify({
            'message': 'Usuario registrado exitosamente',
            'user': new_user.to_dict()
        }), 201
        
    except Exception as e:
        db.session.rollback()
        return jsonify({'error': f'Error al registrar usuario: {str(e)}'}), 500


@auth_bp.route('/login', methods=['POST'])
def login():
    """
    Ruta: POST /login
    Inicia sesión de un usuario
    
    Body (JSON):
        {
            "username": "usuario123",
            "password": "contraseña"
        }
    
    Returns:
        JSON con mensaje de éxito y datos del usuario
    """
    try:
        # Obtener datos del request
        data = request.get_json()
        
        if not data:
            return jsonify({'error': 'No se proporcionaron datos'}), 400
        
        username = data.get('username', '').strip()
        password = data.get('password', '')
        
        if not username or not password:
            return jsonify({'error': 'Username y password son requeridos'}), 400
        
        # Buscar usuario en la base de datos
        user = User.query.filter_by(username=username).first()
        
        # Verificar que el usuario existe y la contraseña es correcta
        if not user or not verify_password(password, user.password_hash):
            return jsonify({'error': 'Credenciales incorrectas'}), 401
        
        # Iniciar sesión con Flask-Login
        login_user(user, remember=True)
        
        return jsonify({
            'message': 'Inicio de sesión exitoso',
            'user': user.to_dict()
        }), 200
        
    except Exception as e:
        return jsonify({'error': f'Error al iniciar sesión: {str(e)}'}), 500


@auth_bp.route('/logout', methods=['GET', 'POST'])
@login_required
def logout():
    """
    Ruta: GET o POST /logout
    Cierra la sesión del usuario actual
    Requiere autenticación (login_required)
    
    Returns:
        JSON con mensaje de confirmación
    """
    try:
        logout_user()
        return jsonify({'message': 'Sesión cerrada exitosamente'}), 200
    except Exception as e:
        return jsonify({'error': f'Error al cerrar sesión: {str(e)}'}), 500


@auth_bp.route('/perfil', methods=['GET'])
@login_required
def perfil():
    """
    Ruta: GET /perfil
    Obtiene los datos del usuario autenticado
    Requiere autenticación (login_required)
    
    Returns:
        JSON con los datos del usuario actual
    """
    try:
        return jsonify({
            'user': current_user.to_dict()
        }), 200
    except Exception as e:
        return jsonify({'error': f'Error al obtener perfil: {str(e)}'}), 500


@auth_bp.route('/check_api_key', methods=['GET'])
def check_api_key():
    """
    Ruta: GET /check_api_key
    ⚠️ ENDPOINT DE DEMOSTRACIÓN - NO USAR EN PRODUCCIÓN ⚠️
    
    Este endpoint es solo un ejemplo educativo para mostrar cómo verificar API Keys.
    
    Headers:
        X-API-Key: demo-api-key-12345
    
    Returns:
        JSON indicando si la API Key es válida
    
    ⚠️ ADVERTENCIA DE SEGURIDAD:
    Este endpoint tiene una API key hardcodeada y es INSEGURO para producción.
    
    Para implementar API Keys en producción:
    1. Crear modelo ApiKey en la base de datos con campos: id, key_hash, user_id, created_at, expires_at
    2. Generar keys aleatorias seguras (ej: secrets.token_urlsafe(32))
    3. Almacenar solo el hash de la key (bcrypt o similar)
    4. Implementar rate limiting para prevenir ataques de fuerza bruta
    5. Permitir rotación de keys (invalidar y generar nuevas)
    6. Agregar permisos/scopes específicos por key
    
    RECOMENDACIÓN: Elimina este endpoint si no lo vas a implementar correctamente.
    """
    try:
        api_key = request.headers.get('X-API-Key')
        
        if not api_key:
            return jsonify({'error': 'API Key no proporcionada'}), 401
        
        # ⚠️ SOLO PARA DEMOSTRACIÓN - NO USAR EN PRODUCCIÓN ⚠️
        # Esta key está hardcodeada y es visible en el código fuente
        demo_api_key = "demo-api-key-12345"
        
        if api_key == demo_api_key:
            return jsonify({
                'message': 'API Key válida (DEMO)',
                'valid': True,
                'warning': 'Este es un endpoint de demostración. No usar en producción.'
            }), 200
        else:
            return jsonify({
                'error': 'API Key inválida',
                'valid': False
            }), 401
            
    except Exception as e:
        return jsonify({'error': f'Error al verificar API Key: {str(e)}'}), 500
