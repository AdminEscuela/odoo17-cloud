#!/bin/bash
set -e

echo "=== ODOO 17 - INICIALIZACIÓN FORZADA ==="
echo "PORT: $PORT"
echo "DB_HOST: $DB_HOST"

sleep 15

# Addons path
ADDONS_PATH="/opt/render/project/src/.venv/lib/python3.13/site-packages/odoo/addons"
echo "Addons: $ADDONS_PATH"

# Verificar si la base de datos necesita inicialización
echo "=== VERIFICANDO ESTADO DE LA BASE DE DATOS ==="
python3 -c "
import psycopg2
import os
import sys

try:
    conn = psycopg2.connect(
        host=os.getenv('DB_HOST'),
        port=int(os.getenv('DB_PORT', 5432)),
        user=os.getenv('DB_USER'),
        password=os.getenv('DB_PASSWORD'),
        database=os.getenv('DB_NAME')
    )
    
    # Verificar si existe alguna tabla de Odoo
    cur = conn.cursor()
    cur.execute('''SELECT EXISTS (
        SELECT FROM information_schema.tables 
        WHERE table_name = 'ir_module_module'
    )''')
    has_tables = cur.fetchone()[0]
    conn.close()
    
    if has_tables:
        print('✅ Base de datos YA INICIALIZADA')
        sys.exit(0)
    else:
        print('🔄 Base de datos VACÍA - necesita inicialización')
        sys.exit(1)
        
except Exception as e:
    print(f'❌ Error verificando BD: {e}')
    print('🔄 Asumiendo que necesita inicialización')
    sys.exit(1)
"

# Si la BD está vacía, inicializarla
if [ $? -ne 0 ]; then
    echo "=== INICIALIZANDO BASE DE DATOS ODOO ==="
    echo "⏰ Esto tomará 5-15 minutos..."
    
    python -m odoo \
        --db_host=$DB_HOST \
        --db_port=$DB_PORT \
        --db_user=$DB_USER \
        --db_password=$DB_PASSWORD \
        --database=$DB_NAME \
        --addons-path="$ADDONS_PATH" \
        --init=base \
        --without-demo=all \
        --stop-after-init
        
    if [ $? -eq 0 ]; then
        echo "🎉 BASE DE DATOS INICIALIZADA EXITOSAMENTE"
    else
        echo "⚠️ Error en inicialización, continuando..."
    fi
fi

echo "=== INICIANDO ODOO ==="
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
