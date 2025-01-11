import 'package:flutter/material.dart';
import 'package:roll_and_reserve/presentation/blocs/tables/table_state.dart';
import 'package:roll_and_reserve/presentation/screens/screen_edit_shop.dart';

class ShopAddTables extends StatelessWidget {
  const ShopAddTables({
    super.key,
    required this.widget,
    required this.state,
  });

  final TableState state;
  final ScreenEditShop widget;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          child: Row(
            children: [
              Text('Mesas disponibles:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const Spacer(),
            ],
          ),
        ),
        SizedBox(height: 16),
        Wrap(
          spacing: 8.0,
          children: state.tables != null
              ? state.tables!
                  .map((table) => Chip(
                      backgroundColor: Colors.teal.shade100,
                      label: Text("Mesa ${table.numberTable.toString()}")))
                  .toList()
              : [],
        ),
      ],
    );
  }
}
