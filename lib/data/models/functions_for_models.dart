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

