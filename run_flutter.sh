#!/bin/bash

# Script para ejecutar Flutter en Docker con acceso a dispositivos USB
# Autor: Tú

# Verifica si Docker está instalado
if ! command -v docker &> /dev/null
then
    echo "Docker no está instalado. Por favor, instálalo e intenta nuevamente."
    exit 1
fi

# Ejecutar el contenedor Docker
echo "Iniciando contenedor Docker para Flutter..."
docker run --rm -it \
    -v "$(pwd):/app" \
    --device /dev/bus/usb:/dev/bus/usb \
    myflutterapp flutter run

