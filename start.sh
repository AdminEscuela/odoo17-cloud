#!/bin/bash
set -e

echo "=== ODOO 17 - REGENERAR ASSETS ==="
sleep 15

# Asegurar que existe el directorio data
mkdir -p /opt/render/project/src/data
mkdir -p /opt/render/project/src/data/filestore
mkdir -p /opt/render/project/src/data/filestore/odoo17_qlxd

# Addons path
ADDONS_PATH="/opt/render/project/src/odoo-source/addons"
echo "Addons: $ADDONS_PATH"

# Regenerar assets forzadamente
echo "=== REGENERANDO ASSETS ==="
python -m odoo \
    --db_host=$DB_HOST \
    --db_port=$DB_PORT \
    --db_user=$DB_USER \
    --db_password=$DB_PASSWORD \
    --database=$DB_NAME \
    --addons-path="$ADDONS_PATH" \
    --update=web \
    --stop-after-init || echo "Assets regenerados"

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
