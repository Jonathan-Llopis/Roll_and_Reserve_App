import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:roll_and_reserve/config/theme/theme.dart';
import 'package:roll_and_reserve/presentation/blocs/login/login_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/login/login_state.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DialogConfirmReserve extends StatelessWidget {
  final String mensaje;
  final bool error;

  const DialogConfirmReserve({super.key, required this.mensaje, required this.error});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
      return AlertDialog(
        title: Text(error ? AppLocalizations.of(context)!.error : AppLocalizations.of(context)!.reserva_confirmada,
            style: TextStyle(
              color: error ? Colors.red : Color(0xFF00695C),
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
              Navigator.of(context).pop(
              );
            },
            child: Text(AppLocalizations.of(context)!.accept),
          ),
        ],
      );
    });
  }
}
