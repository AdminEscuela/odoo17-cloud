#!/bin/bash
set -e

echo "=== ODOO 17 - DEBUG COMPLETO ==="
echo "PORT: $PORT"
echo "DB_HOST: $DB_HOST"
echo "DB_NAME: $DB_NAME"
echo "DB_USER: $DB_USER"

sleep 15

# Addons path
ADDONS_PATH="/opt/render/project/src/.venv/lib/python3.13/site-packages/odoo/addons"
echo "Addons: $ADDONS_PATH"

# Verificar que el módulo web existe
if [ -d "$ADDONS_PATH/web" ]; then
    echo "✅ Módulo web encontrado"
else
    echo "❌ MÓDULO WEB NO ENCONTRADO"
    echo "Buscando en el sistema..."
    find /opt/render/project/src -name "web" -type d 2>/dev/null | head -5
    exit 1
fi

echo "=== INICIALIZACIÓN DE BASE DE DATOS ==="
echo "Ejecutando comando de inicialización..."

# Ejecutar inicialización con máximo logging
python -m odoo \
    --db_host=$DB_HOST \
    --db_port=$DB_PORT \
    --db_user=$DB_USER \
    --db_password=$DB_PASSWORD \
    --database=$DB_NAME \
    --addons-path="$ADDONS_PATH" \
    --init=base \
    --without-demo=all \
    --stop-after-init \
    --log-level=debug

EXIT_CODE=$?
echo "Código de salida de inicialización: $EXIT_CODE"

if [ $EXIT_CODE -eq 0 ]; then
    echo "🎉 INICIALIZACIÓN EXITOSA"
else
    echo "❌ INICIALIZACIÓN FALLÓ"
    echo "Continuando de todos modos..."
fi

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
    --without-demo=all \
    --log-level=info
