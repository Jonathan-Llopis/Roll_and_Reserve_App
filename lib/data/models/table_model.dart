import 'package:roll_and_reserve/data/models/functions_for_models.dart';
import 'package:roll_and_reserve/domain/entities/table_entity.dart';

class TableModel {
  final int id;
  final int numberTable;
  final String stats;
  final int idShop;
  final List<int> reserves;

  TableModel(
      {required this.id,
      required this.numberTable,
      required this.stats,
      required this.reserves,
      required this.idShop});

  factory TableModel.fromJson(Map<String, dynamic> json) {
    return TableModel(
      id: json['id_table'],
      numberTable: json['number_table'],
      stats: json['stats_of_table']==null ? "" : json['stats_of_table']['description'] ?? "",
      reserves: crearListaReservas(json['reserves_of_table'] ?? <String>[]),
      idShop: json['tables_of_shop'] == null ? 0 : json['tables_of_shop']['id_shop'] ?? 0,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id_table': id,
      'number_table': numberTable,
      'stats_of_table': {'description': stats},
      'reserves_of_table': reserves,
      'tables_of_shop': idShop
    };
  }

  TableEntity toTableEntity() {
    return TableEntity(
        id: id,
        numberTable: numberTable,
        stats: stats,
        reserves: reserves,
        idShop: idShop);
  }
}
