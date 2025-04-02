import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:roll_and_reserve/config/theme/theme.dart';
import 'package:roll_and_reserve/presentation/blocs/login/login_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/login/login_state.dart';
import 'package:roll_and_reserve/presentation/blocs/shops/shop_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/shops/shop_event.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class DialogDeleteShop extends StatelessWidget {
  final int idShop;
  final ShopBloc shopBloc;
  const DialogDeleteShop({super.key, required this.idShop, required this.shopBloc});

  @override
  /// Builds a widget that displays a dialog for deleting a shop.
  ///
  /// The dialog shows a confirmation message for deleting the shop
  /// with the specified [idShop]. It provides two actions: cancel and accept.
  /// The cancel button dismisses the dialog without performing any actions.
  /// The accept button dispatches a [DeleteShopEvent] to the [shopBloc]
  /// to delete the shop and navigates the user to the main page.
  ///
  /// The dialog uses the [LoginBloc] to access the current user's state.
  /// The title and content text are localized using [AppLocalizations].

  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
      return AlertDialog(
        title:  Text( AppLocalizations.of(context)!.shop_delete,
            style: TextStyle(
              color: Color.fromARGB(255, 0, 0, 0),
              fontSize: 30,
            )),
        content:  Text(
           AppLocalizations.of(context)!.confirm_delete_shop,
          style: TextStyle(
            fontSize: 18,
            color: Color.fromARGB(255, 0, 0, 0),
          ),
        ),
        actions: <Widget>[
          TextButton(
            style: AppTheme.textButtonCancelStyle,
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          TextButton(
            style: AppTheme.textButtonAcceptStyle,
            onPressed: () {
              shopBloc.add(DeleteShopEvent(
                    idShop: idShop,
                    idOwner: state.user!.id,
                  ));
              context.go('/user');
            },
            child: Text(AppLocalizations.of(context)!.accept),
          ),
        ],
      );
    });
  }
}
