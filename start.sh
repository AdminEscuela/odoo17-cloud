#!/bin/bash
set -e

echo "=== INICIANDO ODOO 17 ==="
echo "Esperando PostgreSQL..."
sleep 15

echo "=== BUSCANDO MÓDULOS ODOO ==="

# Función para encontrar la ruta correcta de addons
find_addons_path() {
    python3 -c "
import odoo
import os
import sys

print('🔍 Buscando módulos Odoo...')

# Rutas posibles donde podrían estar los addons
possible_paths = [
    # Ruta principal de addons
    odoo.addons.__path__[0],
    # Rutas alternativas
    '/opt/render/project/src/.venv/lib/python3.13/site-packages/odoo/addons',
    '/opt/render/project/src/.venv/lib/python3.13/site-packages/odoo/odoo/addons',
    '/opt/render/project/src/.venv/lib/python3.13/site-packages/addons',
    # Ruta de instalación desde GitHub
    '/opt/render/project/src/.venv/lib/python3.13/site-packages/odoo-17.0-py3.13.egg/odoo/addons',
]

# Buscar el módulo web en todas las rutas
for path in possible_paths:
    if os.path.exists(path):
        web_path = os.path.join(path, 'web')
        if os.path.exists(web_path):
            print(f'✅ Módulo web encontrado en: {web_path}')
            print(path)
            sys.exit(0)
        else:
            print(f'ℹ️  Ruta existe pero sin web: {path}')
            # Listar contenido para debugging
            try:
                files = os.listdir(path)
                print(f'   Contenido: {files[:5]}...')
            except:
                print('   No se puede listar contenido')

print('❌ No se encontró el módulo web en ninguna ruta')
print('=== DEBUG: Estructura de directorios ===')
# Buscar recursivamente
import subprocess
try:
    result = subprocess.run(['find', '/opt/render/project/src/.venv', '-name', '*web*', '-type', 'd'], 
                          capture_output=True, text=True, timeout=30)
    print('Directorios web encontrados:')
    print(result.stdout[:2000])
except Exception as e:
    print(f'Error buscando: {e}')

sys.exit(1)
"
}

echo "=== Buscando ruta de addons ==="
ADDONS_PATH=$(find_addons_path)

if [ $? -ne 0 ]; then
    echo "❌ NO SE PUDO ENCONTRAR EL MÓDULO WEB"
    echo "⚠️  Usando ruta por defecto y continuando..."
    ADDONS_PATH="/opt/render/project/src/.venv/lib/python3.13/site-packages/odoo/addons"
fi

echo "Addons path final: $ADDONS_PATH"

# Configuración
DB_HOST=${DB_HOST:-localhost}
DB_PORT=${DB_PORT:-5432}
DB_NAME=${DB_NAME:-odoo17}
DB_USER=${DB_USER:-odoo}
DB_PASSWORD=${DB_PASSWORD:-odoo}
PORT=${PORT:-8069}

echo "=== INICIALIZANDO BASE DE DATOS ==="
python -m odoo \
    --db_host=$DB_HOST \
    --db_port=$DB_PORT \
    --db_user=$DB_USER \
    --db_password=$DB_PASSWORD \
    --database=$DB_NAME \
    --addons-path="$ADDONS_PATH" \
    --init=base \
    --without-demo=all \
    --stop-after-init || echo "⚠️ Inicialización falló o ya estaba hecha"

echo "=== INICIANDO SERVIDOR ODOO ==="
exec python -m odoo \
    --db_host=$DB_HOST \
    --db_port=$DB_PORT \
    --db_user=$DB_USER \
    --db_password=$DB_PASSWORD \
    --database=$DB_NAME \
    --http-port=$PORT \
    --addons-path="$ADDONS_PATH" \
    --without-demo=all
