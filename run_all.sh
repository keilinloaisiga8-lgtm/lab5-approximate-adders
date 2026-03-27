#!/bin/bash
# =============================================================================
# run_all.sh
# Descripción : Script maestro que invoca automáticamente los tres scripts
#               del laboratorio en orden:
#               1. fetch.sh  - Descarga los sumadores aproximados
#               2. synth.sh  - Sintetiza cada diseño con Vivado
#               3. parse.sh  - Extrae métricas y genera results.csv
# Uso         : bash run_all.sh
# Requisitos  : Vivado debe estar en el PATH antes de ejecutar este script
#               Ejemplo: export PATH=/ruta/a/vivado/bin:$PATH
# Autor       : keilinloaisiga8-lgtm
# Fecha       : 2026-03-27
# =============================================================================

set -e

echo "=============================================="
echo " Laboratorio 5 - Sumadores Aproximados"
echo " Flujo automatizado completo"
echo "=============================================="
echo ""

# Verificar que los scripts existen
for SCRIPT in fetch.sh synth.sh parse.sh; do
    if [ ! -f "$SCRIPT" ]; then
        echo "ERROR: No se encontró $SCRIPT"
        exit 1
    fi
done

# Paso 1: Descargar sumadores aproximados
echo "[1/3] Ejecutando fetch.sh..."
echo "----------------------------------------------"
bash fetch.sh
echo ""

# Paso 2: Sintetizar con Vivado
echo "[2/3] Ejecutando synth.sh..."
echo "----------------------------------------------"
bash synth.sh
echo ""

# Paso 3: Extraer métricas y generar CSV
echo "[3/3] Ejecutando parse.sh..."
echo "----------------------------------------------"
bash parse.sh
echo ""

echo "=============================================="
echo " Flujo completado exitosamente"
echo " Resultados en: results.csv"
echo "=============================================="
