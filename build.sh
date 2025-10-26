#!/bin/bash
set -e

echo "=== INSTALACIÓN ODOO 17 - RUTA CORRECTA ==="

cd /opt/render/project/src
rm -rf odoo-17.0 odoo-source 2>/dev/null || true

# Descargar Odoo
wget -q https://github.com/odoo/odoo/archive/refs/heads/17.0.zip -O odoo-17.0.zip
unzip -q odoo-17.0.zip
mv odoo-17.0 odoo-source

# Instalar
cd odoo-source
pip install -e .

# Dependencias
pip install psycopg2-binary Pillow lxml lxml-html-clean python-dateutil requests Jinja2 Werkzeug MarkupSafe Babel greenlet pytz num2words

echo "=== VERIFICACIÓN RUTA CORRECTA ==="
cd /opt/render/project/src
python -c "
import odoo
print('✅ Odoo', odoo.release.version)

# La ruta REAL de los addons
import odoo.addons
addons_path = odoo.addons.__path__[0]
print('✅ Addons path REAL:', addons_path)

# Verificar módulos en la ruta REAL
import os
modules_to_check = ['web', 'base', 'mail']
for module in modules_to_check:
    module_path = os.path.join(addons_path, module)
    if os.path.exists(module_path):
        print(f'✅ {module}: {module_path}')
    else:
        print(f'❌ {module}: NO ENCONTRADO')

print('🎉 VERIFICACIÓN COMPLETADA')
"

mkdir -p /opt/render/project/src/data
echo "=== BUILD COMPLETADO ==="
