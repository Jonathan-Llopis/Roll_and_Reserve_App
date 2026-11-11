import 'package:roll_and_reserve/data/models/user_model.dart';

double calcularMediaRatings(List<dynamic> reviews) {
  if (reviews.isEmpty) {
    return 0.0;
  }
  double sumaRatings = 0.0;
  int contador = 0;

  for (var review in reviews) {
    if (review is Map) {
      final rawRating = review['raiting'] ?? review['rating'];
      if (rawRating is num) {
        sumaRatings += rawRating.toDouble();
        contador++;
      }
    }
  }

  return contador > 0 ? sumaRatings / contador : 0.0;
}

List<int> calcularMesasTienda(List<dynamic> tables) {
  List<int> listTables = [];
  if (tables.isEmpty) {
    return [];
  }

  for (var table in tables) {
    if (table is Map && table['id_table'] != null) {
      listTables.add((table['id_table'] as num).toInt());
    }
  }

  return listTables;
}

List<String> crearListaUsuarios(List<dynamic> users) {
  List<String> listaUsuarios = [];

  if (users.isEmpty) {
    return [];
  }

  for (var user in users) {
    if (user is Map && user['id_google'] != null) {
      listaUsuarios.add(user['id_google'].toString());
    }
  }

  return listaUsuarios;
}

List<int> crearListaReservas(List<dynamic> reserves) {
  List<int> listaReservas = [];

  if (reserves.isEmpty) {
    return [];
  }

  for (var reserve in reserves) {
    if (reserve is Map && reserve['id_reserve'] != null) {
      listaReservas.add((reserve['id_reserve'] as num).toInt());
    }
  }

  return listaReservas;
}

List<int> crearListaJuegos(List<dynamic> reserves) {
  List<int> listaReservas = [];

  if (reserves.isEmpty) {
    return <int>[];
  }

  for (var reserve in reserves) {
    if (reserve is Map && reserve['id_game'] != null) {
      listaReservas.add((reserve['id_game'] as num).toInt());
    }
  }

  return listaReservas;
}

String getDate(String fecha) {
  if (fecha.length < 10) return fecha;
  return '${fecha.substring(8, 10)} - ${fecha.substring(5, 7)} - ${fecha.substring(0, 4)}';
}

String getHour(String fecha) {
  if (fecha.length < 16) return '';
  return '${fecha.substring(11, 13)}:${fecha.substring(14, 16)}';
}

String getIsoDate(String fecha, String hora) {
  List<String> fechaParts = fecha.split(' - ');
  String isoDate =
      '${fechaParts[2]}-${fechaParts[1]}-${fechaParts[0]}T$hora:00Z';
  return isoDate;
}

List<UserModel> crearListaUsuerModel(List<dynamic> users) {
  List<UserModel> listaUsuarios = [];

  if (users.isEmpty) {
    return [];
  }

  for (var user in users) {
    UserModel userModel = UserModel.fromJson(user);
    listaUsuarios.add(userModel);
  }

  return listaUsuarios;
}
