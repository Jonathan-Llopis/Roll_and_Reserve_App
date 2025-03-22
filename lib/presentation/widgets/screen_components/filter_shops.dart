import 'package:flutter/material.dart';
import 'package:roll_and_reserve/presentation/blocs/shops/shop_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/shops/shop_event.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FilterShops extends StatefulWidget {
  final ShopBloc shopBloc;
  const FilterShops({super.key, required this.shopBloc});

  @override
  State<FilterShops> createState() => _FilterShopsState();
}

class _FilterShopsState extends State<FilterShops> {
  final _formKey = GlobalKey<FormState>();
  final _nombreTiendaController = TextEditingController();
  final _localidadTiendaController = TextEditingController();

  @override
  void initState() {
   if(widget.shopBloc.state.filterShops != null){
      if(widget.shopBloc.state.filterShops!.containsKey('name')){
        _nombreTiendaController.text = widget.shopBloc.state.filterShops!['name']!;
      }
      if(widget.shopBloc.state.filterShops!.containsKey('direction')){
        _localidadTiendaController.text = widget.shopBloc.state.filterShops!['direction']!;
      }
   }
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _nombreTiendaController,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.shop_name_text,
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _localidadTiendaController,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.shop_location,
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  widget.shopBloc.add(GetShopByFilterEvent(
                      name: _nombreTiendaController.text,
                      direction: _localidadTiendaController.text));
                  Navigator.of(context).pop();
                 
                }
              },
              child: Text(AppLocalizations.of(context)!.filter),
            ),
          ],
        ),
      ),
    );
  }
}
