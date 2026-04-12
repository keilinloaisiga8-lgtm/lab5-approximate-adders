#!/bin/bash
# =============================================================================
# fetch.sh
# Descripción : Descarga el repositorio de sumadores aproximados, copia los
#               archivos .v al directorio hdl/ en la raíz del proyecto y
#               elimina el resto del contenido descargado.
#               Los archivos _pdk45.v se excluyen ya que usan celdas de
#               librería ASIC no compatibles con síntesis en FPGA (Vivado).
# Uso         : bash fetch.sh
# Autor       : keilinloaisiga8-lgtm
# Fecha       : 2026-03-27
# =============================================================================

set -e

REPO_URL="https://github.com/ehw-fit/evoapproxlib.git"
TMP_DIR="tmp_adders"
HDL_DIR="hdl"

echo ">>> Clonando repositorio de sumadores aproximados..."
git clone "$REPO_URL" "$TMP_DIR"

echo ">>> Creando directorio hdl/..."
mkdir -p "$HDL_DIR"

echo ">>> Copiando archivos .v a hdl/ (excluyendo _pdk45)..."
find "$TMP_DIR/adders/8_unsigned/pareto_pwr_ep" -name "*.v" ! -name "*_pdk45.v" -exec cp {} "$HDL_DIR/" \;

echo ">>> Eliminando directorio temporal..."
rm -rf "$TMP_DIR"

echo ">>> Listo. Archivos .v disponibles en: $HDL_DIR/"
ls "$HDL_DIR"
