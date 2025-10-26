#!/bin/bash
set -e

echo "=== INSTALACIÓN MANUAL ODOO 17 GARANTIZADA ==="

# Limpiar instalaciones previas
cd /opt/render/project/src
rm -rf odoo-17.0 odoo-source 2>/dev/null || true

# Descargar Odoo 17 directamente
echo "=== DESCARGANDO ODOO 17 DESDE GITHUB ==="
wget -q https://github.com/odoo/odoo/archive/refs/heads/17.0.zip -O odoo-17.0.zip

echo "=== DESCOMPRIMIENDO ==="
unzip -q odoo-17.0.zip
mv odoo-17.0 odoo-source

echo "=== INSTALANDO ODOO ==="
cd odoo-source
pip install -e .

echo "=== INSTALANDO DEPENDENCIAS ==="
pip install psycopg2-binary Pillow lxml lxml-html-clean python-dateutil requests Jinja2 Werkzeug MarkupSafe Babel greenlet pytz num2words

echo "=== VERIFICACIÓN FINAL ==="
cd /opt/render/project/src
python -c "
import odoo
print('✅ Odoo', odoo.release.version)

# Verificar addons path REAL
import odoo.addons
addons_path = odoo.addons.__path__[0]
print('✅ Addons path:', addons_path)

# Verificar módulo web
import os
web_path = os.path.join(addons_path, 'web')
if os.path.exists(web_path):
    print('✅ MÓDULO WEB ENCONTRADO:', web_path)
    print('Contenido del directorio web:', os.listdir(web_path)[:5])
else:
    print('❌ MÓDULO WEB NO ENCONTRADO EN:', web_path)
    
# Listar directorio addons completo
print('Contenido de addons:', os.listdir(addons_path))
"

echo "=== CREANDO ESTRUCTURA DE DATOS ==="
mkdir -p /opt/render/project/src/data

echo "🎉 INSTALACIÓN COMPLETADA"
