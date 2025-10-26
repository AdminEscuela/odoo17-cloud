#!/bin/bash
set -e

echo "=== INICIANDO ODOO 17 ==="
echo "Esperando PostgreSQL..."
sleep 15

# Obtener addons path
ADDONS_PATH=$(python -c "import odoo.addons; print(odoo.addons.__path__[0])")
echo "Addons: $ADDONS_PATH"

# Verificar módulo web
if [ -d "$ADDONS_PATH/web" ]; then
    echo "✅ Módulo web encontrado"
else
    echo "❌ Error: Módulo web no encontrado"
    exit 1
fi

# Configuración
DB_HOST=${DB_HOST:-localhost}
DB_PORT=${DB_PORT:-5432}
DB_NAME=${DB_NAME:-odoo17}
DB_USER=${DB_USER:-odoo}
DB_PASSWORD=${DB_PASSWORD:-odoo}
PORT=${PORT:-8069}

echo "=== Inicializando base de datos ==="
python -m odoo \
    --db_host=$DB_HOST \
    --db_port=$DB_PORT \
    --db_user=$DB_USER \
    --db_password=$DB_PASSWORD \
    --database=$DB_NAME \
    --addons-path="$ADDONS_PATH" \
    --init=base \
    --without-demo=all \
    --stop-after-init || echo "⚠️ Inicialización saltada"

echo "=== Iniciando Odoo 17 ==="
exec python -m odoo \
    --db_host=$DB_HOST \
    --db_port=$DB_PORT \
    --db_user=$DB_USER \
    --db_password=$DB_PASSWORD \
    --database=$DB_NAME \
    --http-port=$PORT \
    --addons-path="$ADDONS_PATH" \
    --without-demo=all
