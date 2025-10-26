#!/bin/bash
set -e

echo "=== ODOO 17 - START GARANTIZADO ==="
sleep 15

# Usar la ruta EXACTA donde se instaló Odoo
ADDONS_PATH="/opt/render/project/src/odoo-source/odoo/addons"
echo "Addons path GARANTIZADO: $ADDONS_PATH"

# Verificar que existe
if [ -d "$ADDONS_PATH/web" ]; then
    echo "✅ MÓDULO WEB CONFIRMADO"
    echo "Contenido: $(ls $ADDONS_PATH/web | head -5)"
else
    echo "❌ ERROR CRÍTICO: Módulo web no encontrado"
    echo "Buscando en todo el sistema..."
    find /opt/render/project/src -name "web" -type d 2>/dev/null
    exit 1
fi

# Inicializar base de datos
echo "=== INICIALIZANDO BASE DE DATOS ==="
python -m odoo \
    --db_host=$DB_HOST \
    --db_port=$DB_PORT \
    --db_user=$DB_USER \
    --db_password=$DB_PASSWORD \
    --database=$DB_NAME \
    --addons-path="$ADDONS_PATH" \
    --init=base \
    --without-demo=all \
    --stop-after-init

echo "=== INICIANDO ODOO ==="
exec python -m odoo \
    --db_host=$DB_HOST \
    --db_port=$DB_PORT \
    --db_user=$DB_USER \
    --db_password=$DB_PASSWORD \
    --database=$DB_NAME \
    --http-interface=0.0.0.0 \
    --http-port=$PORT \
    --addons-path="$ADDONS_PATH" \
    --data-dir=/opt/render/project/src/data \
    --without-demo=all
