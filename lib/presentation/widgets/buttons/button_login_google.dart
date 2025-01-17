import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:roll_and_reserve/config/theme/theme.dart';
import 'package:roll_and_reserve/presentation/blocs/login/login_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/login/login_event.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ButtonLoginGoogle extends StatelessWidget {
  const ButtonLoginGoogle({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final loginBloc = BlocProvider.of<LoginBloc>(context);
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: Colors.black12),
        ),
        elevation: 3,
      ),
      onPressed: () {
        context.read<LoginBloc>().add(
              LoginGoogle(),
            );
        if (loginBloc.state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(loginBloc.state.errorMessage!)),
          );
        }
      },
      icon: Image.asset('assets/images/google.png',
          height: 20, width: 20, fit: BoxFit.cover),
      label:  Text(AppLocalizations.of(context)!.google_login, style: AppTheme.googleStyle),
    );
  }
}
