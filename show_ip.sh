#!/data/data/com.termux/files/usr/bin/bash

###############################################################################
# Script Simple - Solo muestra la IP Pública
###############################################################################

# Colores
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo ""
echo "════════════════════════════════════════════════════════════════"
echo "                  INFORMACIÓN DE RED                            "
echo "════════════════════════════════════════════════════════════════"
echo ""

# IP Pública
echo -e "${BLUE}🌐 Obteniendo IP Pública...${NC}"
PUBLIC_IP=$(curl -s --max-time 5 ifconfig.me 2>/dev/null)

if [ -z "$PUBLIC_IP" ]; then
    PUBLIC_IP=$(curl -s --max-time 5 ident.me 2>/dev/null)
fi

if [ -z "$PUBLIC_IP" ]; then
    PUBLIC_IP=$(curl -s --max-time 5 ipecho.net/plain 2>/dev/null)
fi

if [ -z "$PUBLIC_IP" ]; then
    echo -e "${YELLOW}⚠ No se pudo obtener la IP pública${NC}"
    echo "  Verifica tu conexión a internet"
else
    echo ""
    echo -e "${GREEN}✓ IP Pública:${NC}"
    echo ""
    echo "  ┌─────────────────────────────────────┐"
    echo "  │                                     │"
    echo "  │        $PUBLIC_IP           │"
    echo "  │                                     │"
    echo "  └─────────────────────────────────────┘"
fi

echo ""

# IP Local
echo -e "${BLUE}📱 Obteniendo IP Local...${NC}"
LOCAL_IP=$(ifconfig 2>/dev/null | grep 'inet ' | grep -v '127.0.0.1' | awk '{print $2}' | head -1)

if [ -z "$LOCAL_IP" ]; then
    LOCAL_IP=$(ip addr show 2>/dev/null | grep 'inet ' | grep -v '127.0.0.1' | awk '{print $2}' | cut -d/ -f1 | head -1)
fi

if [ ! -z "$LOCAL_IP" ]; then
    echo ""
    echo -e "${GREEN}✓ IP Local (WiFi/Red):${NC}"
    echo ""
    echo "  ┌─────────────────────────────────────┐"
    echo "  │                                     │"
    echo "  │        $LOCAL_IP           │"
    echo "  │                                     │"
    echo "  └─────────────────────────────────────┘"
fi

echo ""
echo "════════════════════════════════════════════════════════════════"
echo ""

# Si existe la API corriendo en puerto 5000
if [ ! -z "$PUBLIC_IP" ]; then
    echo -e "${BLUE}Para acceder a tu API desde internet:${NC}"
    echo "  http://$PUBLIC_IP:5000"
    echo ""
fi

if [ ! -z "$LOCAL_IP" ]; then
    echo -e "${BLUE}Para acceder desde tu red local:${NC}"
    echo "  http://$LOCAL_IP:5000"
    echo ""
fi

echo -e "${YELLOW}NOTA: Para acceso público, configura port forwarding en tu router${NC}"
echo ""
