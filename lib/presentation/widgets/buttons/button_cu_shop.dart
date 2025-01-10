import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:roll_and_reserve/domain/entities/shop_entity.dart';
import 'package:roll_and_reserve/presentation/blocs/login/login_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/shops/shop_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/shops/shop_event.dart';

class CreateUpdateShop extends StatelessWidget {
  const CreateUpdateShop({
    super.key,
    required TextEditingController titleController,
    required TextEditingController adressController,
    required imageFile,
    required this.idShop,
  })  : _titleController = titleController,
        _adressController = adressController,
        _imageFile = imageFile;

  final TextEditingController _titleController;
  final TextEditingController _adressController;
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
                    name: _titleController.text,
                    address: _adressController.text,
                    logo: _imageFile,
                    ownerId: loginBloc.state.user!.id,
                    id: 0,
                    averageRaiting: 0,
                    logoId: '0',
                    tablesShop: 0,
                    gamesShop: []),
              ));
        } else {
          context.read<ShopBloc>().add(UpdateShopEvent(
                  shop: ShopEntity(
                id: idShop,
                name: _titleController.text,
                address: _adressController.text,
                logo: _imageFile,
                averageRaiting: shopBloc.state.shop?.averageRaiting ?? 0,
                logoId: "",
                ownerId: loginBloc.state.user!.id,
                tablesShop: shopBloc.state.shop?.tablesShop ?? 0,
                gamesShop: shopBloc.state.shop?.gamesShop ?? [],
              )));
        }

        context.go('/user');
      },
      child: Text('Aceptar'),
    );
  }
}
