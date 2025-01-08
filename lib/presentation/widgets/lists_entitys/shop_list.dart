import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:roll_and_reserve/domain/entities/shop_entity.dart';
import 'package:roll_and_reserve/main.dart';
import 'package:roll_and_reserve/presentation/blocs/tables/table_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/tables/table_event.dart';
import 'package:roll_and_reserve/presentation/blocs/tables/table_state.dart';
import 'package:roll_and_reserve/presentation/functions/raiting_function.dart';

class ShopListInventory extends StatefulWidget {
  const ShopListInventory({
    super.key,
    required this.shop,
  });

  final ShopEntity shop;

  @override
  State<ShopListInventory> createState() => _ShopListInventoryState();
}

class _ShopListInventoryState extends State<ShopListInventory> {
  @override
  void initState() {
    context
        .read<TableBloc>()
        .add(GetTablesByShopEvent(idShop: widget.shop.id));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TableBloc, TableState>(builder: (context, state) {
      if (state.isLoading) {
        return const Center(child: CircularProgressIndicator());
      } else if (state.errorMessage != null) {
        return Center(child: Text(state.errorMessage!));
      } else if (state.tables != null) {
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 8.0),
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey, width: 1.0),
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  color: Colors.grey[200],
                ),
                child: Center(
                  child: kIsWeb
                      ? (widget.shop.logo is Uint8List
                          ? Image(
                              image: MemoryImage(widget.shop.logo),
                              fit: BoxFit.cover,
                            )
                          : null)
                      : Image(
                          image: FileImage(File(widget.shop.logo.path)),
                          fit: BoxFit.cover,
                        ),
                ),
              ),
              const SizedBox(width: 12.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.shop.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      widget.shop.address,
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    const SizedBox(height: 8.0),
                    Wrap(
                      spacing: 8.0,
                      runSpacing: 4.0,
                      children: state.tables!.map((table) {
                        return Chip(label: Text('Mesa ${table.numberTable}'));
                      }).toList(),
                    )
                  ],
                ),
              ),
              const SizedBox(width: 12.0),
              Column(
                children: [
                  Row(
                    children: [
                      Icon(Icons.table_bar, size: 16),
                      SizedBox(width: 4.0),
                      Text('Total Tables: ${state.tables!.length}'),
                    ],
                  ),
                  const SizedBox(height: 8.0),
                  buildStars(widget.shop.averageRaiting)
                ],
              ),
            ],
          ),
        );
      } else {
        return Container();
      }
    });
  }
}
