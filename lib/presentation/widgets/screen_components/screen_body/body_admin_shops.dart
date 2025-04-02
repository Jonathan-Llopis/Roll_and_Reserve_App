import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:roll_and_reserve/domain/entities/shop_entity.dart';
import 'package:roll_and_reserve/presentation/blocs/shops/shop_bloc.dart';
import 'package:roll_and_reserve/presentation/widgets/information/information_shop.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

List<ShopEntity>? shops;

class BodyAdminShops extends StatefulWidget {
  const BodyAdminShops({
    super.key,
  });

  @override
  State<BodyAdminShops> createState() => _BodyMainState();
}

class _BodyMainState extends State<BodyAdminShops> {
  @override
  /// Initialize the shops list with the ones from the ShopBloc state.
  /// This is done to have a reference to the list of shops that doesn't change
  /// when the state of the bloc changes, which is important because the list
  /// is used in the build method of this class.
  void initState() {
    ShopBloc shopBloc = BlocProvider.of<ShopBloc>(context);
    shops ??= shopBloc.state.shops!;
    super.initState();
  }

  @override
  /// Builds a Column with a TextField that filters the shops by their name
  /// and a ListView of InformationShop widgets that show the shops that
  /// match the filter.
  Widget build(BuildContext context) {
    ShopBloc shopBloc = BlocProvider.of<ShopBloc>(context);
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: TextField(
            onChanged: (value) {
              setState(() {
                shops = shopBloc.state.shops!
                    .where((shop) =>
                        shop.name.toLowerCase().contains(value.toLowerCase()))
                    .toList();
              });
            },
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context)!.shop_name_text,
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          ),
        ),
        const Divider(height: 1, thickness: 1),
        Expanded(
            child: ListView.builder(
          itemCount: shops!.length,
          itemBuilder: (context, index) {
            final shop = shops![index];
            return Builder(builder: (context) => InformationShop(shop: shop));
          },
        )),
      ],
    );
  }
}
