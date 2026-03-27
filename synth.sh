#!/bin/bash
# =============================================================================
# synth.sh
# Descripción : Itera sobre los archivos .v en hdl/, sintetiza cada uno
#               usando Vivado para la tarjeta xc7a100tcsg324-1 (Nexys A7)
#               y guarda los reportes con el mismo nombre del archivo .v
#               pero con extensión .log en la carpeta reports/
#               Si un archivo falla, se registra el error y continúa.
# Uso         : bash synth.sh
# Autor       : keilinloaisiga8-lgtm
# Fecha       : 2026-03-27
# =============================================================================

# Verificar que Vivado esté disponible en el PATH
if ! command -v vivado &> /dev/null; then
    echo "ERROR: Vivado no encontrado en el PATH."
    echo "Por favor agregue Vivado al PATH antes de correr este script."
    echo "Ejemplo: export PATH=/ruta/a/vivado/bin:\$PATH"
    exit 1
fi

# Directorio donde están los archivos .v
HDL_DIR="hdl"

# Directorio donde se guardan los reportes
REPORTS_DIR="reports"

# Parte objetivo (Nexys A7)
PART="xc7a100tcsg324-1"

# Contadores de éxito y fallo
SUCCESS=0
FAILED=0

# Crear directorio de reportes si no existe
mkdir -p "$REPORTS_DIR"

echo ">>> Iniciando síntesis de sumadores aproximados..."
echo ">>> Parte objetivo: $PART"
echo ""

# Iterar sobre cada archivo .v en hdl/
for V_FILE in "$HDL_DIR"/*.v; do

    # Obtener el nombre del archivo sin ruta ni extensión
    BASENAME=$(basename "$V_FILE" .v)

    # Leer el nombre real del módulo desde adentro del archivo .v
    MODULE=$(grep "^module" "$V_FILE" | head -1 | awk '{print $2}' | cut -d'(' -f1)

    echo ">>> Sintetizando: $BASENAME (módulo: $MODULE)"

    # Crear script TCL temporal para Vivado
    TCL_SCRIPT="tmp_synth.tcl"

    echo "set_part \"$PART\""                       > "$TCL_SCRIPT"
    echo "read_verilog {$V_FILE}"                  >> "$TCL_SCRIPT"
    echo "synth_design -top $MODULE -part $PART"   >> "$TCL_SCRIPT"
    echo "report_utilization"                      >> "$TCL_SCRIPT"
    echo "exit"                                    >> "$TCL_SCRIPT"

    # Ejecutar Vivado en modo batch y guardar reporte
    if vivado -mode batch -source "$TCL_SCRIPT" -log "$REPORTS_DIR/$BASENAME.log" -nojournal; then
        echo ">>> OK: $REPORTS_DIR/$BASENAME.log"
        SUCCESS=$((SUCCESS + 1))
    else
        echo ">>> FALLO: $BASENAME no se pudo sintetizar (ver $REPORTS_DIR/$BASENAME.log)"
        FAILED=$((FAILED + 1))
    fi
    echo ""

done

# Borrar script TCL temporal
rm -f "$TCL_SCRIPT"

echo ">>> Síntesis completada."
echo ">>> Exitosos : $SUCCESS"
echo ">>> Fallidos : $FAILED"
echo ">>> Reportes en: $REPORTS_DIR/"
ls "$REPORTS_DIR/"
