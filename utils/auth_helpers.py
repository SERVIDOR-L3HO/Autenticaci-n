"""
Funciones auxiliares para autenticación
Maneja el hash de contraseñas y validaciones de datos
"""
import bcrypt
import re

def hash_password(password: str) -> str:
    """
    Hashea una contraseña usando bcrypt
    
    Args:
        password: Contraseña en texto plano
        
    Returns:
        Contraseña hasheada como string
    """
    # Genera un salt y hashea la contraseña
    salt = bcrypt.gensalt()
    hashed = bcrypt.hashpw(password.encode('utf-8'), salt)
    return hashed.decode('utf-8')


def verify_password(password: str, password_hash: str) -> bool:
    """
    Verifica si una contraseña coincide con su hash
    
    Args:
        password: Contraseña en texto plano a verificar
        password_hash: Hash almacenado en la base de datos
        
    Returns:
        True si coincide, False si no
    """
    try:
        return bcrypt.checkpw(password.encode('utf-8'), password_hash.encode('utf-8'))
    except Exception:
        return False


def validate_username(username: str) -> tuple[bool, str]:
    """
    Valida que el username cumpla con los requisitos
    
    Requisitos:
    - Entre 3 y 30 caracteres
    - Solo letras, números, guiones y guiones bajos
    
    Args:
        username: Nombre de usuario a validar
        
    Returns:
        Tupla (es_válido, mensaje_error)
    """
    if not username:
        return False, "El nombre de usuario es requerido"
    
    if len(username) < 3:
        return False, "El nombre de usuario debe tener al menos 3 caracteres"
    
    if len(username) > 30:
        return False, "El nombre de usuario no puede tener más de 30 caracteres"
    
    # Solo permite letras, números, guiones y guiones bajos
    if not re.match(r'^[a-zA-Z0-9_-]+$', username):
        return False, "El nombre de usuario solo puede contener letras, números, guiones y guiones bajos"
    
    return True, ""


def validate_password(password: str) -> tuple[bool, str]:
    """
    Valida que la contraseña cumpla con los requisitos de seguridad
    
    Requisitos:
    - Al menos 6 caracteres (ajustar según necesites)
    
    Args:
        password: Contraseña a validar
        
    Returns:
        Tupla (es_válida, mensaje_error)
    """
    if not password:
        return False, "La contraseña es requerida"
    
    if len(password) < 6:
        return False, "La contraseña debe tener al menos 6 caracteres"
    
    # Opcional: Agregar más validaciones como mayúsculas, números, caracteres especiales
    # if not re.search(r'[A-Z]', password):
    #     return False, "La contraseña debe contener al menos una mayúscula"
    
    return True, ""
