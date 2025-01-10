double calcularMediaRatings(List<dynamic> reviews) {
  double sumaRatings = 0;
  int contador = 0;

  if (reviews.isEmpty) {
    return 0;
  }

  for (var review in reviews) {
    sumaRatings += review['raiting'] as int;
    contador++;
  }

  return contador > 0 ? sumaRatings / contador : 0;
}

int calcularMesasTienda(List<dynamic> mesas) {
  if (mesas.isEmpty) {
    return 0;
  }

  return mesas.length;
}

List<String> crearListaUsuarios(List<dynamic> users) {
  List<String> listaUsuarios = [];

  if (users.isEmpty) {
    return [];
  }

  for (var user in users) {
    listaUsuarios.add(user['id_google']);
  }

  return listaUsuarios;
}

List<int> crearListaReservas(List<dynamic> reserves) {
  List<int> listaReservas = [];

  if (reserves.isEmpty) {
    return [];
  }

  for (var reserve in reserves) {
    listaReservas.add(reserve['id_reserve']);
  }

  return listaReservas;
}

List<int> crearListaJuegos(List<dynamic> reserves) {
  List<int> listaReservas = [];

  if (reserves.isEmpty) {
    return <int>[];
  }

  for (var reserve in reserves) {
    listaReservas.add(reserve['id_game']);
  }

  return listaReservas;
}

String getDate(String fecha) {
  return "${fecha.substring(8, 10)} - ${fecha.substring(5, 7)} - ${fecha.substring(0, 4)}";
}

String getHour(String fecha) {
  return "${fecha.substring(11, 13)}:${fecha.substring(14, 16)}";
}
String getIsoDate(String fecha, String hora) {
  List<String> fechaParts = fecha.split("-");
  String isoDate = "${fechaParts[2]}-${fechaParts[1]}-${fechaParts[0]}T$hora:00Z";
  return isoDate;
}