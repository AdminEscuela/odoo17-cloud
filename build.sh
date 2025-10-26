#!/bin/bash
set -e

echo "=== INSTALACIÓN COMPLETA ODOO 17 ==="
python -m pip install --upgrade pip

echo "=== Descargando Odoo desde GitHub ==="
# Descargar y instalar manualmente
cd /opt/render/project/src
wget https://github.com/odoo/odoo/archive/refs/heads/17.0.zip -O odoo-17.0.zip
unzip -q odoo-17.0.zip
cd odoo-17.0

echo "=== Instalando Odoo en desarrollo mode ==="
pip install -e .

echo "=== Instalando dependencias ==="
pip install psycopg2-binary Pillow lxml lxml-html-clean python-dateutil requests Jinja2 Werkzeug MarkupSafe Babel greenlet pytz num2words

echo "=== Verificando ==="
python -c "
import odoo
print(f'✅ Odoo {odoo.release.version}')
import odoo.addons
path = odoo.addons.__path__[0]
print(f'Addons: {path}')
import os
print(f'Contenido: {os.listdir(path)[:10]}')
"

echo "=== Build completado ==="
