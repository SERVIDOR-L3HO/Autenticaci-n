#!/data/data/com.termux/files/usr/bin/bash

###############################################################################
# Script de Instalación para Termux - API de Autenticación Flask
# Instala automáticamente todo lo necesario y lanza el servidor
###############################################################################

echo "╔════════════════════════════════════════════════════════════════╗"
echo "║   Instalador Automático - API Flask PostgreSQL para Termux    ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo ""

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # Sin color

# Función para imprimir mensajes
print_step() {
    echo -e "${BLUE}➤ $1${NC}"
}

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

###############################################################################
# PASO 1: Actualizar repositorios de Termux
###############################################################################
print_step "Actualizando repositorios de Termux..."
pkg update -y && pkg upgrade -y
if [ $? -eq 0 ]; then
    print_success "Repositorios actualizados correctamente"
else
    print_error "Error al actualizar repositorios"
    exit 1
fi
echo ""

###############################################################################
# PASO 2: Instalar Python
###############################################################################
print_step "Instalando Python..."
pkg install python -y
if [ $? -eq 0 ]; then
    PYTHON_VERSION=$(python --version)
    print_success "Python instalado: $PYTHON_VERSION"
else
    print_error "Error al instalar Python"
    exit 1
fi
echo ""

###############################################################################
# PASO 3: Instalar PostgreSQL
###############################################################################
print_step "Instalando PostgreSQL..."
pkg install postgresql -y
if [ $? -eq 0 ]; then
    print_success "PostgreSQL instalado correctamente"
else
    print_error "Error al instalar PostgreSQL"
    exit 1
fi
echo ""

###############################################################################
# PASO 4: Inicializar PostgreSQL
###############################################################################
print_step "Inicializando base de datos PostgreSQL..."
if [ ! -d "$PREFIX/var/lib/postgresql" ]; then
    initdb $PREFIX/var/lib/postgresql
    print_success "Base de datos PostgreSQL inicializada"
else
    print_warning "PostgreSQL ya estaba inicializado"
fi
echo ""

###############################################################################
# PASO 5: Iniciar servidor PostgreSQL
###############################################################################
print_step "Iniciando servidor PostgreSQL..."
pg_ctl -D $PREFIX/var/lib/postgresql start
sleep 3
if pg_ctl -D $PREFIX/var/lib/postgresql status > /dev/null 2>&1; then
    print_success "Servidor PostgreSQL corriendo"
else
    print_error "Error al iniciar PostgreSQL"
    exit 1
fi
echo ""

###############################################################################
# PASO 6: Crear base de datos para la aplicación
###############################################################################
print_step "Creando base de datos 'auth_db'..."
createdb auth_db 2>/dev/null
if [ $? -eq 0 ]; then
    print_success "Base de datos 'auth_db' creada"
else
    print_warning "La base de datos podría ya existir (esto es normal)"
fi
echo ""

###############################################################################
# PASO 7: Actualizar pip
###############################################################################
print_step "Actualizando pip..."
pip install --upgrade pip
print_success "pip actualizado"
echo ""

###############################################################################
# PASO 8: Instalar dependencias de Python
###############################################################################
print_step "Instalando dependencias de Python (esto puede tardar unos minutos)..."
echo ""

# Instalar cada dependencia con feedback
dependencies=(
    "Flask==3.0.0"
    "Flask-SQLAlchemy==3.1.1"
    "Flask-Login==0.6.3"
    "Flask-CORS==4.0.0"
    "psycopg2-binary==2.9.9"
    "bcrypt==4.1.2"
    "python-dotenv==1.0.0"
)

for dep in "${dependencies[@]}"; do
    echo -e "  ${BLUE}→${NC} Instalando $dep..."
    pip install "$dep" --quiet
    if [ $? -eq 0 ]; then
        echo -e "    ${GREEN}✓${NC} $dep instalado"
    else
        echo -e "    ${RED}✗${NC} Error instalando $dep"
    fi
done

print_success "Todas las dependencias instaladas"
echo ""

###############################################################################
# PASO 9: Configurar variables de entorno
###############################################################################
print_step "Configurando variables de entorno..."

# Crear archivo .env si no existe
if [ ! -f .env ]; then
    cat > .env << EOF
# Variables de entorno para Termux
SECRET_KEY=$(python -c "import secrets; print(secrets.token_hex(32))")
DATABASE_URL=postgresql://localhost/auth_db
ENVIRONMENT=development
CORS_ORIGINS=*
PORT=5000
EOF
    print_success "Archivo .env creado con configuración para Termux"
else
    print_warning "Archivo .env ya existe, no se sobrescribirá"
fi
echo ""

###############################################################################
# PASO 10: Crear alias útiles
###############################################################################
print_step "Creando alias útiles en .bashrc..."

# Agregar alias si no existen
if ! grep -q "pgstart" ~/.bashrc 2>/dev/null; then
    cat >> ~/.bashrc << 'EOF'

# Alias para PostgreSQL
alias pgstart='pg_ctl -D $PREFIX/var/lib/postgresql start'
alias pgstop='pg_ctl -D $PREFIX/var/lib/postgresql stop'
alias pgstatus='pg_ctl -D $PREFIX/var/lib/postgresql status'

# Alias para la API
alias apistart='python app.py'
alias myip='curl -s ifconfig.me'
EOF
    print_success "Alias agregados a .bashrc"
else
    print_warning "Los alias ya existen en .bashrc"
fi
echo ""

###############################################################################
# PASO 11: Instalar curl para obtener IP pública
###############################################################################
print_step "Verificando curl (para obtener IP pública)..."
if ! command -v curl &> /dev/null; then
    pkg install curl -y
    print_success "curl instalado"
else
    print_success "curl ya está instalado"
fi
echo ""

###############################################################################
# INSTALACIÓN COMPLETA
###############################################################################
echo ""
echo "╔════════════════════════════════════════════════════════════════╗"
echo "║              ✓ INSTALACIÓN COMPLETADA EXITOSAMENTE            ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo ""

###############################################################################
# OBTENER IP PÚBLICA
###############################################################################
print_step "Obteniendo tu IP pública..."
PUBLIC_IP=$(curl -s --max-time 5 ifconfig.me 2>/dev/null)

if [ -z "$PUBLIC_IP" ]; then
    # Intentar con otro servicio
    PUBLIC_IP=$(curl -s --max-time 5 ident.me 2>/dev/null)
fi

if [ -z "$PUBLIC_IP" ]; then
    print_warning "No se pudo obtener la IP pública (verifica tu conexión a internet)"
else
    print_success "IP Pública obtenida: $PUBLIC_IP"
fi
echo ""

###############################################################################
# OBTENER IP LOCAL
###############################################################################
print_step "Obteniendo tu IP local..."
LOCAL_IP=$(ifconfig 2>/dev/null | grep 'inet ' | grep -v '127.0.0.1' | awk '{print $2}' | head -1)

if [ -z "$LOCAL_IP" ]; then
    LOCAL_IP=$(ip addr show 2>/dev/null | grep 'inet ' | grep -v '127.0.0.1' | awk '{print $2}' | cut -d/ -f1 | head -1)
fi

if [ -z "$LOCAL_IP" ]; then
    print_warning "No se pudo obtener la IP local"
else
    print_success "IP Local: $LOCAL_IP"
fi
echo ""

###############################################################################
# INFORMACIÓN DE ACCESO
###############################################################################
echo "════════════════════════════════════════════════════════════════"
echo "                    INFORMACIÓN DE ACCESO                       "
echo "════════════════════════════════════════════════════════════════"
echo ""
echo -e "${GREEN}✓ PostgreSQL:${NC} Corriendo en puerto 5432"
echo -e "${GREEN}✓ Base de datos:${NC} auth_db"
echo ""
echo -e "${BLUE}Para iniciar la API, ejecuta:${NC}"
echo "  python app.py"
echo ""
echo -e "${BLUE}La API estará disponible en:${NC}"
echo "  • Localhost:         http://localhost:5000"
if [ ! -z "$LOCAL_IP" ]; then
    echo "  • Red local:         http://$LOCAL_IP:5000"
fi
if [ ! -z "$PUBLIC_IP" ]; then
    echo "  • IP Pública:        http://$PUBLIC_IP:5000"
fi
echo ""
echo -e "${YELLOW}NOTA: Para acceso desde internet público, necesitas configurar${NC}"
echo -e "${YELLOW}port forwarding en tu router (puerto 5000 → $LOCAL_IP:5000)${NC}"
echo ""
echo "════════════════════════════════════════════════════════════════"
echo "                      COMANDOS ÚTILES                           "
echo "════════════════════════════════════════════════════════════════"
echo ""
echo "  pgstart         - Iniciar PostgreSQL"
echo "  pgstop          - Detener PostgreSQL"
echo "  pgstatus        - Ver estado de PostgreSQL"
echo "  apistart        - Iniciar la API"
echo "  myip            - Ver tu IP pública"
echo ""
echo -e "${GREEN}Ejecuta 'source ~/.bashrc' para activar los alias ahora${NC}"
echo ""
echo "════════════════════════════════════════════════════════════════"
echo ""

# Preguntar si quiere iniciar la API ahora
read -p "¿Quieres iniciar la API ahora? (s/n): " -n 1 -r
echo
if [[ $REPLY =~ ^[SsYy]$ ]]; then
    print_step "Iniciando la API..."
    echo ""
    python app.py
else
    echo ""
    print_success "Para iniciar la API más tarde, ejecuta: python app.py"
    echo ""
fi
