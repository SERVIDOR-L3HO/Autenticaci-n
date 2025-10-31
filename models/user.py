"""
Modelo de Usuario para la base de datos
Define la estructura de la tabla 'users' con SQLAlchemy
"""
from flask_sqlalchemy import SQLAlchemy
from flask_login import UserMixin
from datetime import datetime

# Instancia de SQLAlchemy (se inicializa en app.py)
db = SQLAlchemy()

class User(db.Model, UserMixin):
    """
    Modelo de Usuario
    
    Campos:
    - id: Identificador único del usuario (Primary Key)
    - username: Nombre de usuario único
    - password_hash: Contraseña hasheada con bcrypt (nunca se guarda en texto plano)
    - role: Rol del usuario (ej: 'user', 'admin')
    - created_at: Fecha de creación del registro
    """
    
    __tablename__ = 'users'
    
    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String(80), unique=True, nullable=False, index=True)
    password_hash = db.Column(db.String(255), nullable=False)
    role = db.Column(db.String(20), default='user', nullable=False)
    created_at = db.Column(db.DateTime, default=datetime.utcnow, nullable=False)
    
    def __repr__(self):
        """Representación en string del objeto User"""
        return f'<User {self.username}>'
    
    def to_dict(self):
        """
        Convierte el objeto User a diccionario
        Útil para respuestas JSON (sin exponer el password_hash)
        """
        return {
            'id': self.id,
            'username': self.username,
            'role': self.role,
            'created_at': self.created_at.isoformat() if self.created_at else None
        }
