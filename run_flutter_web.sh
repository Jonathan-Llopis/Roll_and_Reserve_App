#!/bin/bash

# Script para ejecutar Flutter en Docker en modo web
# Autor: Tú


# Ejecutar el contenedor Docker
echo "Iniciando contenedor Docker para Flutter en la web..."
docker run --rm -it \
    -v "$(pwd):/app" \
    -p 8080:8080 \
    myflutterapp flutter run -d web-server --web-hostname=0.0.0.0 --web-port=8080
