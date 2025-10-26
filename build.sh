#!/bin/bash
set -e

echo "=== INSTALANDO ODOO 17 CON DEPENDENCIAS COMPLETAS ==="
python -m pip install --upgrade pip

echo "=== Instalando dependencias ==="
pip install -r requirements.txt

echo "=== Verificando instalación ==="
python -c "
try:
    import odoo
    print(f'✅ Odoo {odoo.release.version} instalado correctamente')
    
    # Verificar módulos críticos
    import odoo.addons
    addons_path = odoo.addons.__path__[0]
    print(f'📁 Addons path: {addons_path}')
    
    import os
    modules_to_check = ['web', 'base', 'mail']
    for module in modules_to_check:
        module_path = os.path.join(addons_path, module)
        if os.path.exists(module_path):
            print(f'✅ Módulo {module} encontrado')
        else:
            print(f'❌ Módulo {module} NO encontrado')
            
    # Verificar dependencias importantes
    try:
        from lxml.html.clean import Cleaner
        print('✅ lxml-html-clean funcionando')
    except ImportError as e:
        print(f'❌ lxml-html-clean error: {e}')
        
except Exception as e:
    print(f'❌ Error general: {e}')
    import traceback
    traceback.print_exc()
    exit(1)
"

echo "=== Build completado exitosamente ==="
