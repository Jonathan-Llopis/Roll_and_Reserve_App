import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:roll_and_reserve/config/theme/theme.dart';
import 'package:roll_and_reserve/presentation/blocs/login/login_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/login/login_state.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DialogErrorDatepicker extends StatelessWidget {
  final String mensaje;
  final int idShop;
  const DialogErrorDatepicker({super.key, required this.mensaje, required this.idShop});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
      return AlertDialog(
        title: Text(AppLocalizations.of(context)!.error,
            style: TextStyle(
              color: Colors.red ,
              fontSize: 30,
            )),
        content: Text( mensaje,
          style: TextStyle(
            fontSize: 18,
            color: Color.fromARGB(255, 0, 0, 0),
          ),
        ),
        actions: <Widget>[
          TextButton(
            style: AppTheme.textButtonAcceptStyle,
            onPressed: () {
                context.go('/user/events/$idShop');
            },
            child: Text(AppLocalizations.of(context)!.accept),
          ),
        ],
      );
    });
  }
}
