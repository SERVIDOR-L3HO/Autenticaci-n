#!/data/data/com.termux/files/usr/bin/bash

###############################################################################
# Script para Túnel SSH con localhost.run - El más simple
# No requiere instalación, solo SSH
# Dominio tipo: https://abc123.localhost.run
###############################################################################

# Colores
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo ""
echo "╔════════════════════════════════════════════════════════════════╗"
echo "║      Túnel SSH (localhost.run) - Sin instalación extra         ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo ""

# Verificar si openssh está instalado
if ! command -v ssh &> /dev/null; then
    echo -e "${YELLOW}⚠ SSH no está instalado. Instalando...${NC}"
    pkg install openssh -y
    echo -e "${GREEN}✓ SSH instalado${NC}"
    echo ""
fi

echo "════════════════════════════════════════════════════════════════"
echo "  🚀 Creando túnel SSH en puerto 5000..."
echo "════════════════════════════════════════════════════════════════"
echo ""
echo -e "${GREEN}Tu API estará disponible en un dominio tipo:${NC}"
echo "  https://abc123xyz.localhost.run"
echo ""
echo -e "${BLUE}IMPORTANTE:${NC}"
echo "  • La URL cambia cada vez que reinicias el túnel"
echo "  • Es GRATIS y sin límites"
echo "  • Presiona Ctrl+C para detener"
echo ""
echo "════════════════════════════════════════════════════════════════"
echo ""

# Crear túnel SSH
ssh -R 80:localhost:5000 nokey@localhost.run
