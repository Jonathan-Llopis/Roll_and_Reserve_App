FROM instrumentisto/flutter

# Copia el proyecto al contenedor
WORKDIR /app
COPY . /app/

# Ejecuta flutter pub get para descargar las dependencias
RUN flutter pub get

# Comando para iniciar la aplicación en un emulador o dispositivo conectado
CMD ["tail", "-f", "/dev/null"]