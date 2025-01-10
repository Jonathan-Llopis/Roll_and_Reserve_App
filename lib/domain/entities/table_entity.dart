
import 'package:roll_and_reserve/data/models/table_model.dart';

class TableEntity {
  final int id;
  final int numberTable;
  final String stats;
  final List<int> reserves;
  final int idShop;


  TableEntity(
      {
        required this.id,
        required this.numberTable,
        required this.stats,
        required this.reserves,
        required this.idShop
      });

  TableModel toTableModel() {
    return TableModel(
        id: id,
        numberTable: numberTable,
        stats: stats,
        reserves: reserves,
        idShop : idShop);
  }
}