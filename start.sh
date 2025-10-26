#!/bin/bash
set -e

echo "=== ODOO 17 - RUTA CORRECTA ==="
sleep 15

# ¡ESTA ES LA RUTA CORRECTA!
ADDONS_PATH="/opt/render/project/src/odoo-source/addons"
echo "Addons path CORREGIDO: $ADDONS_PATH"

# Verificar que existe el módulo web
if [ -d "$ADDONS_PATH/web" ]; then
    echo "✅ MÓDULO WEB ENCONTRADO FINALMENTE!"
    echo "Contenido del módulo web: $(ls $ADDONS_PATH/web | head -5)"
else
    echo "❌ ERROR: Módulo web no encontrado en ruta corregida"
    exit 1
fi

# Verificar otros módulos esenciales
ESSENTIAL_MODULES=("base" "web" "mail")
for module in "${ESSENTIAL_MODULES[@]}"; do
    if [ -d "$ADDONS_PATH/$module" ]; then
        echo "✅ Módulo $module encontrado"
    else
        echo "❌ Módulo $module NO encontrado"
    fi
done

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
