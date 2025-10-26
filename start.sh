#!/bin/bash
set -e

echo "=== ODOO 17 - REGENERACIÓN COMPLETA DE ASSETS ==="
sleep 15

# Asegurar directorios
mkdir -p /opt/render/project/src/data/filestore/odoo17_qlxd

# Addons path
ADDONS_PATH="/opt/render/project/src/odoo-source/addons"

# REGENERACIÓN COMPLETA DE ASSETS
echo "=== REGENERANDO ASSETS COMPLETAMENTE ==="
python -c "
import os
import shutil

# Eliminar assets existentes para forzar regeneración
assets_path = '/opt/render/project/src/data/filestore/odoo17_qlxd'
if os.path.exists(assets_path):
    print('Eliminando assets corruptos...')
    # No eliminar todo, solo buscar archivos específicos problemáticos
    for root, dirs, files in os.walk(assets_path):
        for file in files:
            if 'web.assets' in file:
                file_path = os.path.join(root, file)
                print(f'Eliminando: {file_path}')
                os.remove(file_path)
print('Listo para regeneración completa')
"

# Forzar regeneración con comando específico
python -m odoo shell --db_host=$DB_HOST --db_port=$DB_PORT --db_user=$DB_USER --db_password=$DB_PASSWORD --database=$DB_NAME << "PYTHONCODE"
print('Regenerando assets desde consola...')
env = self.env
# Buscar y eliminar attachments de assets corruptos
assets = env['ir.attachment'].search([('name', 'ilike', 'web.assets')])
if assets:
    print(f'Eliminando {len(assets)} assets corruptos')
    assets.unlink()
print('Assets listos para regeneración')
PYTHONCODE

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
    --dev=all
