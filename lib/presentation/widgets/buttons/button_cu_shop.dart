import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:roll_and_reserve/config/theme/theme.dart';
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
    required this.idUserController,
  }) : _imageFile = imageFile;

  final TextEditingController titleController;
  final TextEditingController adressController;
  final TextEditingController longitudController;
  final TextEditingController latitudController;
  final TextEditingController idUserController;
  final dynamic _imageFile;
  final int idShop;
  @override
/// Builds a [TextButton] for creating or updating a shop.
///
/// The button's appearance is styled using [AppTheme.textButtonAcceptStyle].
/// When pressed, it determines if the shop is new (idShop == 0) or existing,
/// and dispatches either a [CreateShopEvent] or an [UpdateShopEvent] to the
/// [ShopBloc] with the shop details gathered from the provided controllers.
/// Once the operation is complete, it navigates to the user page.
///
/// The shop details include the name, address, logo, owner ID, location
/// (latitude and longitude), and other properties. The owner ID is determined
/// based on the role of the logged-in user, using the [LoginBloc].
///
/// Uses:
/// - [BlocProvider] to access [LoginBloc] and [ShopBloc].
/// - [TextEditingController] to retrieve input data.
/// - [AppLocalizations] for localization of button text.

  Widget build(BuildContext context) {
    final loginBloc = BlocProvider.of<LoginBloc>(context);
    final shopBloc = BlocProvider.of<ShopBloc>(context);
    return TextButton(
      style: AppTheme.textButtonAcceptStyle,
      onPressed: () {
        if (idShop == 0) {
          context.read<ShopBloc>().add(CreateShopEvent(
                  shop: ShopEntity(
                name: titleController.text,
                address: adressController.text,
                logo: _imageFile,
                ownerId: loginBloc.state.user!.role == 0 ? idUserController.text : loginBloc.state.user!.id,
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
                ownerId: loginBloc.state.user!.role == 0 ? idUserController.text : loginBloc.state.user!.id,
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
