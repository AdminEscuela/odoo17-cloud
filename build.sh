#!/bin/bash
set -e

echo "=== INSTALANDO ODOO 17 ==="
python -m pip install --upgrade pip
pip install -r requirements.txt

echo "✅ Odoo 17 instalado correctamente"
python -c "import odoo; print(f'Odoo {odoo.release.version} listo')"
