#!/bin/bash
set -e

echo "=== INICIANDO ODOO 17 ==="
echo "=== CONFIGURACIÓN DE PUERTOS ==="

# Debug: mostrar variable PORT
echo "PORT variable: $PORT"
echo "DB_HOST: $DB_HOST"

# Si PORT no está definido, usar default
if [ -z "$PORT" ]; then
    PORT=8069
    echo "⚠️ PORT no definido, usando: $PORT"
else
    echo "✅ PORT definido: $PORT"
fi

# Esperar PostgreSQL
echo "Esperando PostgreSQL..."
sleep 15

# Obtener addons path
echo "Buscando addons path..."
ADDONS_PATH=$(python -c "import odoo.addons; print(odoo.addons.__path__[0])" 2>/dev/null || echo "/opt/render/project/src/.venv/lib/python3.13/site-packages/odoo/addons")
echo "Addons path: $ADDONS_PATH"

# Verificar módulo web
if [ -d "$ADDONS_PATH/web" ]; then
    echo "✅ Módulo web encontrado"
else
    echo "❌ Módulo web NO encontrado, pero continuando..."
fi

# Configuración de base de datos
DB_HOST=${DB_HOST:-localhost}
DB_PORT=${DB_PORT:-5432}
DB_NAME=${DB_NAME:-odoo17}
DB_USER=${DB_USER:-odoo}
DB_PASSWORD=${DB_PASSWORD:-odoo}

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
echo "🚀 INICIANDO EN PUERTO: $PORT"

# Forzar opciones de network para Render
exec python -m odoo \
    --db_host=$DB_HOST \
    --db_port=$DB_PORT \
    --db_user=$DB_USER \
    --db_password=$DB_PASSWORD \
    --database=$DB_NAME \
    --http-interface=0.0.0.0 \
    --http-port=$PORT \
    --addons-path="$ADDONS_PATH" \
    --without-demo=all
