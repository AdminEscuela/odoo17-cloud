#!/bin/bash
set -e

echo "=== ODOO 17 - REGENERACIÓN COMPLETA ==="
sleep 20

# Addons path
ADDONS_PATH="/opt/render/project/src/odoo-source/addons"

# REGENERACIÓN MANUAL DE ASSETS
echo "=== REGENERANDO ASSETS MANUALMENTE ==="
python3 -c "
import os
import subprocess
import time

print('Forzando regeneración de assets...')

# Método 1: Actualizar módulo web
try:
    result = subprocess.run([
        'python', '-m', 'odoo',
        '--db_host=$DB_HOST',
        '--db_port=$DB_PORT', 
        '--db_user=$DB_USER',
        '--db_password=$DB_PASSWORD',
        '--database=$DB_NAME',
        '--addons-path=$ADDONS_PATH',
        '--update=web',
        '--stop-after-init',
        '--without-demo=all'
    ], capture_output=True, text=True, timeout=300)
    print('Método 1 completado')
except Exception as e:
    print(f'Método 1 falló: {e}')

# Método 2: Shell command para regenerar
try:
    from odoo.tools import config
    config['addons_path'] = '$ADDONS_PATH'
    config['db_host'] = '$DB_HOST'
    config['db_port'] = '$DB_PORT'
    config['db_user'] = '$DB_USER' 
    config['db_password'] = '$DB_PASSWORD'
    config['db_name'] = '$DB_NAME'
    
    import odoo
    odoo.tools.config.parse_config([])
    odoo.modules.registry.Registry.new('$DB_NAME')
    print('Registry cargado - assets deberían regenerarse')
except Exception as e:
    print(f'Método 2 falló: {e}')

print('Assets regeneration attempted')
"

echo "=== INICIANDO ODOO EN MODO DESARROLLO ==="
# Modo desarrollo regenera assets automáticamente
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
    --dev=all
