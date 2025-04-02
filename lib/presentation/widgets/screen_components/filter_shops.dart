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
  /// Called when the widget is inserted into the tree.
  ///
  /// This method is responsible for filling the text fields with the values
  /// of the filters of the shops, if they are not null.
  ///
  /// The filters of the shops are the ones that are currently applied to the
  /// list of shops shown in the main screen.
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
  /// Builds a widget that shows a form with two text fields and a button.
  ///
  /// The text fields are used to filter the shops by their name and direction.
  /// The button is used to apply the filters to the list of shops shown in
  /// the main screen.
  ///
  /// The filters are applied by calling the [GetShopByFilterEvent] event
  /// of the [ShopBloc] with the values of the text fields.
  ///
  /// The widget is wrapped in a [Padding] with a padding of 20.0 on all sides.
  /// The widget is also wrapped in a [Form] with a [GlobalKey] that is used
  /// to validate the form.
  ///
  /// The form contains a [TextFormField] for the shop name and a
  /// [TextFormField] for the shop direction. The shop name is used to filter
  /// the shops by their name, and the shop direction is used to filter the
  /// shops by their direction.
  ///
  /// The form also contains a button with the text "Filtrar" that is used to
  /// apply the filters to the list of shops shown in the main screen.
  ///
  /// When the button is pressed, the [GetShopByFilterEvent] event is called
  /// with the values of the text fields. The filters are then applied to the
  /// list of shops shown in the main screen.
  ///
  /// If the form is not valid, the button is not enabled.
  ///
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
