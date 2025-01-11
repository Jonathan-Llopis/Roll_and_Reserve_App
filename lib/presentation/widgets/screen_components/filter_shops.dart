import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/shops/shop_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/shops/shop_event.dart';

class FilterShops extends StatefulWidget {
  const FilterShops({super.key});

  @override
  State<FilterShops> createState() => _FilterShopsState();
}

class _FilterShopsState extends State<FilterShops> {
  final _formKey = GlobalKey<FormState>();
  final _nombreTiendaController = TextEditingController();
  final _localidadTiendaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _nombreTiendaController,
              decoration: const InputDecoration(
                labelText: 'Nombre de tienda',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _localidadTiendaController,
              decoration: const InputDecoration(
                labelText: 'Localidad de tienda',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  context.read<ShopBloc>().add(GetShopByFilterEvent(
                      name: _nombreTiendaController.text,
                      direction: _localidadTiendaController.text));
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Filtrar'),
            ),
          ],
        ),
      ),
    );
  }
}
