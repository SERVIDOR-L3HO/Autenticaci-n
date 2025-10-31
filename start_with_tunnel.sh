#!/data/data/com.termux/files/usr/bin/bash

###############################################################################
# Script Completo - Inicia PostgreSQL + API + Túnel todo junto
###############################################################################

# Colores
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo ""
echo "╔════════════════════════════════════════════════════════════════╗"
echo "║       Iniciar API Flask con Dominio Público Automático        ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo ""

# Función para limpiar al salir
cleanup() {
    echo ""
    echo -e "${YELLOW}Deteniendo servicios...${NC}"
    pkill -f "python app.py"
    pg_ctl -D $PREFIX/var/lib/postgresql stop 2>/dev/null
    echo -e "${GREEN}✓ Servicios detenidos${NC}"
    exit 0
}

trap cleanup EXIT INT TERM

# Paso 1: Iniciar PostgreSQL
echo -e "${BLUE}→ Iniciando PostgreSQL...${NC}"
pg_ctl -D $PREFIX/var/lib/postgresql start 2>/dev/null
sleep 2

if pg_ctl -D $PREFIX/var/lib/postgresql status > /dev/null 2>&1; then
    echo -e "${GREEN}✓ PostgreSQL corriendo${NC}"
else
    echo -e "${RED}✗ Error al iniciar PostgreSQL${NC}"
    exit 1
fi
echo ""

# Paso 2: Iniciar la API en segundo plano
echo -e "${BLUE}→ Iniciando API Flask en puerto 5000...${NC}"
python app.py > api.log 2>&1 &
API_PID=$!
sleep 3

# Verificar que la API esté corriendo
if curl -s http://localhost:5000/ > /dev/null 2>&1; then
    echo -e "${GREEN}✓ API corriendo en http://localhost:5000${NC}"
else
    echo -e "${RED}✗ Error al iniciar la API${NC}"
    echo "Ver logs: cat api.log"
    exit 1
fi
echo ""

# Paso 3: Elegir tipo de túnel
echo "════════════════════════════════════════════════════════════════"
echo "  Selecciona el tipo de túnel para tu dominio público:"
echo "════════════════════════════════════════════════════════════════"
echo ""
echo "  1) Túnel SSH (localhost.run) - RECOMENDADO"
echo "     • Gratis, sin límites"
echo "     • No requiere cuenta"
echo "     • Dominio tipo: https://abc123.localhost.run"
echo ""
echo "  2) LocalTunnel"
echo "     • Gratis"
echo "     • Puedes elegir nombre personalizado"
echo "     • Dominio tipo: https://tu-nombre.loca.lt"
echo ""
echo "  3) ngrok"
echo "     • Requiere cuenta gratuita"
echo "     • Más estable"
echo "     • Dominio tipo: https://abc123.ngrok-free.app"
echo ""
echo -n "Opción (1/2/3): "
read -r opcion

echo ""

case $opcion in
    1)
        echo -e "${GREEN}Iniciando túnel SSH...${NC}"
        echo ""
        # Verificar SSH
        if ! command -v ssh &> /dev/null; then
            pkg install openssh -y
        fi
        ssh -R 80:localhost:5000 nokey@localhost.run
        ;;
    2)
        echo -e "${GREEN}Iniciando LocalTunnel...${NC}"
        echo ""
        # Verificar Node.js y lt
        if ! command -v node &> /dev/null; then
            pkg install nodejs -y
        fi
        if ! command -v lt &> /dev/null; then
            npm install -g localtunnel
        fi
        
        echo -n "Nombre personalizado (opcional): "
        read -r subdomain
        
        if [ -z "$subdomain" ]; then
            lt --port 5000
        else
            lt --port 5000 --subdomain "$subdomain"
        fi
        ;;
    3)
        echo -e "${GREEN}Iniciando ngrok...${NC}"
        echo ""
        # Verificar ngrok
        if ! command -v ngrok &> /dev/null; then
            echo "ngrok no está instalado. Ejecuta primero: ./tunnel_ngrok.sh"
            exit 1
        fi
        ngrok http 5000
        ;;
    *)
        echo -e "${RED}Opción inválida${NC}"
        exit 1
        ;;
esac
