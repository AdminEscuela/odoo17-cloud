#!/bin/bash
set -e

echo "=== ODOO 17 - RENDER SPECIFIC ==="

# Render asigna el PORT automáticamente, debemos usarlo
if [ -z "$PORT" ]; then
    echo "❌ ERROR: PORT no está definido"
    echo "Render debe asignar la variable PORT automáticamente"
    exit 1
fi

echo "✅ PORT asignado por Render: $PORT"

sleep 15

# Configuración mínima para Render
ADDONS_PATH="/opt/render/project/src/.venv/lib/python3.13/site-packages/odoo/addons"

echo "Iniciando Odoo en 0.0.0.0:$PORT"
exec python -m odoo \
    --db_host=$DB_HOST \
    --db_port=$DB_PORT \
    --db_user=$DB_USER \
    --db_password=$DB_PASSWORD \
    --database=$DB_NAME \
    --http-interface=0.0.0.0 \
    --http-port=$PORT \
    --addons-path="$ADDONS_PATH" \
    --without-demo=all
