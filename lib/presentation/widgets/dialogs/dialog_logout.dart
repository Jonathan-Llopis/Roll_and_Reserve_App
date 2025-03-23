import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:roll_and_reserve/config/theme/theme.dart';
import 'package:roll_and_reserve/presentation/blocs/login/login_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/login/login_event.dart';
import 'package:roll_and_reserve/presentation/blocs/login/login_state.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DialogLogOut extends StatelessWidget {
  const DialogLogOut({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
      return AlertDialog(
        title: Text(AppLocalizations.of(context)!.user_logout,
            style: TextStyle(
              color: Color.fromARGB(255, 0, 0, 0),
              fontSize: 30,
            )),
        content: Text(
          AppLocalizations.of(context)!.confirm_logout,
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
              context.read<LoginBloc>().add(LogoutButtonPressed());
              context.go('/login');
            },
            child: Text(AppLocalizations.of(context)!.accept),
          ),
        ],
      );
    });
  }
}
