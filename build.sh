#!/bin/bash
set -e

echo "=== INSTALANDO ODOO 17 ==="
python -m pip install --upgrade pip

echo "=== Instalando dependencias ==="
pip install -r requirements.txt

echo "=== Verificando instalación ==="
python -c "
try:
    import odoo
    print(f'✅ Odoo {odoo.release.version} instalado correctamente')
    print(f'📍 Ruta: {odoo.__file__}')
    
    # Verificar addons
    import odoo.addons
    print(f'📁 Addons path: {odoo.addons.__path__[0]}')
    
    # Verificar módulo web
    import os
    web_path = os.path.join(odoo.addons.__path__[0], 'web')
    if os.path.exists(web_path):
        print(f'✅ Módulo web encontrado: {web_path}')
    else:
        print(f'❌ Módulo web NO encontrado')
        
except Exception as e:
    print(f'❌ Error: {e}')
    import traceback
    traceback.print_exc()
    exit(1)
"

echo "=== Build completado ==="
