#!/bin/bash
# =============================================================================
# parse.sh
# Descripción : Lee los archivos .log en reports/, extrae los valores de
#               Slice LUTs y Slice Registers de cada reporte de Vivado
#               y genera un archivo results.csv con los resultados.
# Uso         : bash parse.sh
# Autor       : keilinloaisiga8-lgtm
# Fecha       : 2026-03-27
# =============================================================================

REPORTS_DIR="reports"
CSV_FILE="results.csv"

if [ ! -d "$REPORTS_DIR" ]; then
    echo "ERROR: No existe el directorio $REPORTS_DIR"
    echo "Por favor ejecute primero synth.sh"
    exit 1
fi

echo ">>> Generando $CSV_FILE..."
echo "design,slice_luts,slice_registers" > "$CSV_FILE"

for LOG_FILE in "$REPORTS_DIR"/*.log; do

    if [[ "$LOG_FILE" == *".backup.log" ]]; then
        continue
    fi

    DESIGN=$(basename "$LOG_FILE" .log)

    # Extraer valores usando | como separador de columnas
    LUTS=$(grep "Slice LUTs\*" "$LOG_FILE" | head -1 | awk -F"|" '{print $3}' | tr -d ' ')
    REGS=$(grep "Slice Registers " "$LOG_FILE" | head -1 | awk -F"|" '{print $3}' | tr -d ' ')

    if [ -z "$LUTS" ]; then LUTS="N/A"; fi
    if [ -z "$REGS" ]; then REGS="N/A"; fi

    echo "$DESIGN,$LUTS,$REGS" >> "$CSV_FILE"
    echo ">>> $DESIGN -> LUTs: $LUTS, Registers: $REGS"

done

echo ""
echo ">>> CSV generado: $CSV_FILE"
cat "$CSV_FILE"
