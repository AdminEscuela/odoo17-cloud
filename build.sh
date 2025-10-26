#!/bin/bash
set -e

echo "=== INSTALACIÓN ODOO 17 ==="
python -m pip install --upgrade pip
pip install -r requirements.txt

echo "=== VERIFICANDO CONFIGURACIÓN RENDER ==="
python -c "
import os
print('Variables de entorno críticas:')
print(f'PORT: {os.getenv(\\\"PORT\\\", \\\"NO DEFINIDO\\\")}')
print(f'DB_HOST: {os.getenv(\\\"DB_HOST\\\", \\\"NO DEFINIDO\\\")}')
print(f'DB_NAME: {os.getenv(\\\"DB_NAME\\\", \\\"NO DEFINIDO\\\")}')
"

python -c "import odoo; print(f'✅ Odoo {odoo.release.version}')"
