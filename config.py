"""
Configuración de la aplicación Flask
Maneja la configuración de la base de datos, SECRET_KEY y entorno
"""
import os
from dotenv import load_dotenv

load_dotenv()

class Config:
    """Clase de configuración base para la aplicación Flask"""
    
    # Secret key para sesiones y cookies
    # En producción, esto se debe configurar como variable de entorno
    SECRET_KEY = os.getenv('SECRET_KEY', 'dev-secret-key-change-in-production')
    
    # Configuración de la base de datos PostgreSQL
    # DATABASE_URL viene configurada automáticamente en Replit y Render
    DATABASE_URL = os.getenv('DATABASE_URL')
    
    # Fix para compatibilidad de SQLAlchemy con PostgreSQL
    # Render y algunos servicios usan postgres:// pero SQLAlchemy necesita postgresql://
    if DATABASE_URL and DATABASE_URL.startswith('postgres://'):
        DATABASE_URL = DATABASE_URL.replace('postgres://', 'postgresql://', 1)
    
    SQLALCHEMY_DATABASE_URI = DATABASE_URL or 'sqlite:///local.db'
    SQLALCHEMY_TRACK_MODIFICATIONS = False
    
    # Configuración de sesiones
    SESSION_COOKIE_SECURE = os.getenv('ENVIRONMENT', 'development') == 'production'
    SESSION_COOKIE_HTTPONLY = True
    SESSION_COOKIE_SAMESITE = 'Lax'
    
    # CORS - Configurar según tus necesidades
    CORS_ORIGINS = os.getenv('CORS_ORIGINS', '*').split(',')
