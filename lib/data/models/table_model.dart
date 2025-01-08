import 'package:roll_and_reserve/data/models/functions_for_models.dart';
import 'package:roll_and_reserve/domain/entities/table_entity.dart';

class TableModel {
  final int id;
  final int numberTable;
  final String freePlaces;
  final String stats;
  final int idShop;
  final List<String> users;
  final List<int> reserves;

  TableModel(
      {required this.id,
      required this.numberTable,
      required this.freePlaces,
      required this.stats,
      required this.users,
      required this.reserves,
      required this.idShop});

  factory TableModel.fromJson(Map<String, dynamic> json) {
    return TableModel(
      id: json['id_table'],
      numberTable: json['number_table'],
      freePlaces: json['free_places'],
      stats: json['stats_of_table']==null ? "" : json['stats_of_table']['description'] ?? "",
      users: crearListaUsuarios(json['users_in_table'] ?? <String>[]),
      reserves: crearListaReservas(json['reserves_of_table'] ?? <String>[]),
      idShop: json['tables_of_shop'] == null ? 0 : json['tables_of_shop']['id_shop'] ?? 0,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id_table': id,
      'number_table': numberTable,
      'free_places': freePlaces,
      'stats_of_table': {'description': stats},
      'users_in_table': users,
      'reserves_of_table': reserves,
      'tables_of_shop': idShop
    };
  }

  TableEntity toTableEntity() {
    return TableEntity(
        id: id,
        numberTable: numberTable,
        freePlaces: freePlaces,
        stats: stats,
        users: users,
        reserves: reserves,
        idShop: idShop);
  }
}
