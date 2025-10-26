#!/bin/bash
set -e

echo "=== INSTALACIÓN ODOO 17 ==="
python -m pip install --upgrade pip
pip install -r requirements.txt

echo "=== VERIFICANDO CONFIGURACIÓN RENDER ==="
python -c "
import os
print('Variables de entorno críticas:')
print('PORT:', os.getenv('PORT', 'NO DEFINIDO'))
print('DB_HOST:', os.getenv('DB_HOST', 'NO DEFINIDO'))
print('DB_NAME:', os.getenv('DB_NAME', 'NO DEFINIDO'))
"

python -c "import odoo; print(f'✅ Odoo {odoo.release.version}')"
python -c "import odoo.addons; print(f'✅ Addons path: {odoo.addons.__path__[0]}')"
