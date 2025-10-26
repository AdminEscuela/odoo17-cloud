#!/bin/bash
set -e

echo "=== ODOO 17 - CONFIGURACIÓN DE RED ==="
echo "PORT: $PORT"
echo "DB_HOST: $DB_HOST"

sleep 20

# Addons path
ADDONS_PATH="/opt/render/project/src/odoo-source/addons"
echo "Addons: $ADDONS_PATH"

# Verificar que Odoo puede iniciar
echo "=== VERIFICANDO ODOO ==="
python -c "
import odoo
print('✅ Odoo importado')
import odoo.addons
print('✅ Addons cargados')
"

# Iniciar Odoo con configuración EXPLÍCITA de red
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
    --without-demo=all \
    --log-level=info
