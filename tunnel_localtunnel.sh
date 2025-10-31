#!/data/data/com.termux/files/usr/bin/bash

###############################################################################
# Script para LocalTunnel - Dominio público tipo:
# https://nombre-personalizado.loca.lt
###############################################################################

# Colores
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo ""
echo "╔════════════════════════════════════════════════════════════════╗"
echo "║      LocalTunnel - Dominio Personalizado para tu API          ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo ""

# Verificar si Node.js está instalado
if ! command -v node &> /dev/null; then
    echo -e "${YELLOW}⚠ Node.js no está instalado. Instalando...${NC}"
    pkg install nodejs -y
    echo -e "${GREEN}✓ Node.js instalado${NC}"
    echo ""
fi

# Instalar localtunnel si no está instalado
if ! command -v lt &> /dev/null; then
    echo -e "${BLUE}→ Instalando LocalTunnel...${NC}"
    npm install -g localtunnel
    echo -e "${GREEN}✓ LocalTunnel instalado${NC}"
    echo ""
fi

# Preguntar por nombre personalizado
echo -e "${BLUE}¿Quieres usar un nombre personalizado para tu dominio?${NC}"
echo "Ejemplo: mi-api-auth"
echo ""
echo -n "Nombre (o presiona Enter para uno aleatorio): "
read -r subdomain

echo ""
echo "════════════════════════════════════════════════════════════════"
echo "  🚀 Iniciando túnel LocalTunnel en puerto 5000..."
echo "════════════════════════════════════════════════════════════════"
echo ""

if [ -z "$subdomain" ]; then
    echo -e "${GREEN}Tu API estará disponible en:${NC}"
    echo "  https://[aleatorio].loca.lt"
    echo ""
    lt --port 5000
else
    echo -e "${GREEN}Tu API estará disponible en:${NC}"
    echo "  https://$subdomain.loca.lt"
    echo ""
    echo -e "${YELLOW}NOTA: Si el nombre está en uso, se asignará uno aleatorio${NC}"
    echo ""
    lt --port 5000 --subdomain "$subdomain"
fi
