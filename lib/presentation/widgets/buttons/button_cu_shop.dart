import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:roll_and_reserve/domain/entities/shop_entity.dart';
import 'package:roll_and_reserve/presentation/blocs/login/login_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/shops/shop_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/shops/shop_event.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ButtonCreateUpdateShop extends StatelessWidget {
  const ButtonCreateUpdateShop({
    super.key,
    required this.titleController,
    required this.adressController,
    required this.longitudController,
    required this.latitudController,
    required imageFile,
    required this.idShop,
  }) : _imageFile = imageFile;

  final TextEditingController titleController;
  final TextEditingController adressController;
  final TextEditingController longitudController;
  final TextEditingController latitudController;
  final dynamic _imageFile;
  final int idShop;
  @override
  Widget build(BuildContext context) {
    final loginBloc = BlocProvider.of<LoginBloc>(context);
    final shopBloc = BlocProvider.of<ShopBloc>(context);
    return ElevatedButton(
      onPressed: () {
        if (idShop == 0) {
          context.read<ShopBloc>().add(CreateShopEvent(
                  shop: ShopEntity(
                name: titleController.text,
                address: adressController.text,
                logo: _imageFile,
                ownerId: loginBloc.state.user!.id,
                id: 0,
                averageRaiting: 0,
                logoId: '0',
                tablesShop: [],
                gamesShop: [],
                latitude: double.parse(latitudController.text),
                longitude: double.parse(longitudController.text),
              )));
        } else {
          context.read<ShopBloc>().add(UpdateShopEvent(
                  shop: ShopEntity(
                id: idShop,
                name: titleController.text,
                address: adressController.text,
                logo: _imageFile,
                averageRaiting: shopBloc.state.shop?.averageRaiting ?? 0,
                logoId: "",
                ownerId: loginBloc.state.user!.id,
                tablesShop: shopBloc.state.shop?.tablesShop ?? [],
                gamesShop: shopBloc.state.shop?.gamesShop ?? [],
                latitude: double.parse(latitudController.text),
                longitude: double.parse(longitudController.text),
              )));
        }

        context.go('/user');
      },
      child: Text(AppLocalizations.of(context)!.accept),
    );
  }
}
