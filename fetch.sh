#!/bin/bash
# =============================================================================
# fetch.sh
# Descripción : Descarga el repositorio de sumadores aproximados, copia los
#               archivos .v al directorio hdl/ en la raíz del proyecto y
#               elimina el resto del contenido descargado.
# Uso         : bash fetch.sh
# Autor       : keilinloaisiga8-lgtm
# Fecha       : 2026-03-26
# =============================================================================

set -e  # Detener el script si ocurre algún error

# URL del repositorio de sumadores aproximados
REPO_URL="https://github.com/ehw-fit/evoapproxlib.git"

# Directorio temporal para clonar
TMP_DIR="tmp_adders"

# Directorio destino para los archivos .v
HDL_DIR="hdl"

echo ">>> Clonando repositorio de sumadores aproximados..."
git clone "$REPO_URL" "$TMP_DIR"

echo ">>> Creando directorio hdl/..."
mkdir -p "$HDL_DIR"

echo ">>> Copiando archivos .v a hdl/..."
find "$TMP_DIR/adders/8_unsigned/pareto_pwr_ep" -name "*.v" -exec cp {} "$HDL_DIR/" \;

echo ">>> Eliminando directorio temporal..."
rm -rf "$TMP_DIR"

echo ">>> Listo. Archivos .v disponibles en: $HDL_DIR/"
ls "$HDL_DIR"

