#!/bin/bash
set -e

echo "=== INSTALANDO ODOO 17 DESDE GITHUB ==="
python -m pip install --upgrade pip

echo "=== Instalando Odoo y dependencias ==="
pip install -r requirements.txt

echo "=== Verificando instalación ==="
python -c "
try:
    import odoo
    print(f'🎉 ODOO {odoo.release.version} INSTALADO CORRECTAMENTE')
    print(f'📍 Ruta: {odoo.__file__}')
    
    # Verificar addons path
    import odoo.addons
    addons_path = odoo.addons.__path__[0]
    print(f'📁 Addons path: {addons_path}')
    
    # Verificar módulos esenciales
    import os
    essential_modules = ['web', 'base', 'mail']
    for module in essential_modules:
        module_path = os.path.join(addons_path, module)
        if os.path.exists(module_path):
            print(f'✅ Módulo {module} encontrado')
        else:
            print(f'❌ Módulo {module} NO encontrado')
            # Listar contenido para debugging
            print(f'   Contenido de {addons_path}:')
            try:
                print(f'   {os.listdir(addons_path)[:10]}')
            except:
                print('   No se pudo listar contenido')
    
    print('✅ TODAS LAS VERIFICACIONES COMPLETADAS')
    
except Exception as e:
    print(f'❌ ERROR CRÍTICO: {e}')
    import traceback
    traceback.print_exc()
    exit(1)
"

echo "=== BUILD EXITOSO ==="
