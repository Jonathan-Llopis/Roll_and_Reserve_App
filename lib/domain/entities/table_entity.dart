
import 'package:roll_and_reserve/data/models/table_model.dart';

class TableEntity {
  final int id;
  final int numberTable;
  final String freePlaces;
  final String stats;
  final List<String> users;
  final List<int> reserves;
  final int idShop;


  TableEntity(
      {
        required this.id,
        required this.numberTable,
        required this.freePlaces,
        required this.stats,
        required this.users,
        required this.reserves,
        required this.idShop
      });

  TableModel toTableModel() {
    return TableModel(
        id: id,
        numberTable: numberTable,
        freePlaces: freePlaces,
        stats: stats,
        users: users,
        reserves: reserves,
        idShop : idShop);
  }
}