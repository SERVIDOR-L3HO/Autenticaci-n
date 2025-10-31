#!/data/data/com.termux/files/usr/bin/bash

###############################################################################
# Script para Túnel ngrok - Convierte tu IP en un dominio tipo:
# https://abc123.ngrok-free.app
###############################################################################

# Colores
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo ""
echo "╔════════════════════════════════════════════════════════════════╗"
echo "║         Túnel ngrok - Dominio Público para tu API             ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo ""

# Verificar si ngrok está instalado
if ! command -v ngrok &> /dev/null; then
    echo -e "${YELLOW}⚠ ngrok no está instalado. Instalando...${NC}"
    echo ""
    
    # Instalar wget si no está
    if ! command -v wget &> /dev/null; then
        pkg install wget -y
    fi
    
    # Descargar ngrok para Android (ARM64)
    echo -e "${BLUE}→ Descargando ngrok...${NC}"
    cd ~
    wget https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-arm64.tgz
    
    # Extraer
    tar xvzf ngrok-v3-stable-linux-arm64.tgz
    chmod +x ngrok
    
    # Mover a una carpeta en el PATH
    mv ngrok $PREFIX/bin/
    
    # Limpiar
    rm ngrok-v3-stable-linux-arm64.tgz
    
    echo -e "${GREEN}✓ ngrok instalado correctamente${NC}"
    echo ""
fi

# Verificar si necesita autenticación
if [ ! -f ~/.config/ngrok/ngrok.yml ]; then
    echo -e "${YELLOW}════════════════════════════════════════════════════════════════${NC}"
    echo -e "${YELLOW}  CONFIGURACIÓN INICIAL DE NGROK${NC}"
    echo -e "${YELLOW}════════════════════════════════════════════════════════════════${NC}"
    echo ""
    echo "Para usar ngrok necesitas una cuenta GRATUITA:"
    echo ""
    echo "1. Ve a: https://dashboard.ngrok.com/signup"
    echo "2. Regístrate (es gratis)"
    echo "3. Copia tu authtoken de: https://dashboard.ngrok.com/get-started/your-authtoken"
    echo ""
    echo -e "${BLUE}Pega tu authtoken aquí (o presiona Enter para continuar sin él):${NC}"
    read -r authtoken
    
    if [ ! -z "$authtoken" ]; then
        ngrok config add-authtoken "$authtoken"
        echo -e "${GREEN}✓ Token configurado${NC}"
    else
        echo -e "${YELLOW}⚠ Continuando sin token (sesiones limitadas a 2 horas)${NC}"
    fi
    echo ""
fi

# Iniciar ngrok
echo "════════════════════════════════════════════════════════════════"
echo "  🚀 Iniciando túnel ngrok en puerto 5000..."
echo "════════════════════════════════════════════════════════════════"
echo ""
echo -e "${GREEN}Tu API estará disponible en un dominio público tipo:${NC}"
echo "  https://abc123-456.ngrok-free.app"
echo ""
echo -e "${BLUE}IMPORTANTE:${NC}"
echo "  • La URL cambia cada vez que reinicias ngrok"
echo "  • Con cuenta gratuita el túnel dura hasta que cierres este script"
echo "  • Presiona Ctrl+C para detener el túnel"
echo ""
echo "════════════════════════════════════════════════════════════════"
echo ""

# Iniciar ngrok
ngrok http 5000
