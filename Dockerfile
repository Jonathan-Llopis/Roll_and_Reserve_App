FROM instrumentisto/flutter

# Copia el proyecto al contenedor
WORKDIR /app
COPY . /app/

# Ejecuta flutter pub get para descargar las dependencias
RUN flutter pub get

# Construye la app para Android
RUN flutter build apk --debug

# Comando para iniciar la aplicación en un emulador o dispositivo conectado
CMD ["flutter", "emulators", "--launch", "emulator-5554", "&&", "flutter", "run"]