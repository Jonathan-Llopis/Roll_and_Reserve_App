import 'package:flutter/material.dart';
import 'package:roll_and_reserve/presentation/widgets/tables_list.dart';

Future<void> mostrarModalBottom(BuildContext context, int idShop) {
  return showModalBottomSheet<void>(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    isScrollControlled: true,
    builder: (BuildContext context) {
      return TablesShow(idShop: idShop);
    },
  );
}
