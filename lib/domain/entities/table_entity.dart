import 'package:equatable/equatable.dart';

class TableEntity extends Equatable {
  final int id;
  final int numberTable;
  final String stats;
  final List<int> reserves;
  final int idShop;

  const TableEntity({
    required this.id,
    required this.numberTable,
    required this.stats,
    required this.reserves,
    required this.idShop,
  });

  TableEntity copyWith({
    int? id,
    int? numberTable,
    String? stats,
    List<int>? reserves,
    int? idShop,
  }) {
    return TableEntity(
      id: id ?? this.id,
      numberTable: numberTable ?? this.numberTable,
      stats: stats ?? this.stats,
      reserves: reserves ?? this.reserves,
      idShop: idShop ?? this.idShop,
    );
  }

  @override
  List<Object?> get props => [id, numberTable, stats, reserves, idShop];
}
