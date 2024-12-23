#!/bin/bash

# Script para ejecutar Flutter en Docker con acceso a dispositivos USB
# Autor: Tú

# Verifica si Docker está instalado
# Ejecutar el contenedor Docker
echo "Iniciando contenedor Docker para Flutter..."
docker run --rm -it \
    -v "$(pwd):/app" \
    --device /dev/bus/usb:/dev/bus/usb \
    myflutterapp flutter run

