import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:roll_and_reserve/presentation/blocs/language/language_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/language/language_event.dart';

class ChangeLanguageDialog extends StatelessWidget {
  const ChangeLanguageDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(AppLocalizations.of(context)!.changeLanguage),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.flag, color: Colors.blue),
            title:  Text(AppLocalizations.of(context)!.english),
            onTap: () {
              context
                  .read<LanguageBloc>()
                  .add(ChangeLanguageEvent(const Locale('en')));
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            leading: const Icon(Icons.flag, color: Colors.red),
            title:  Text(AppLocalizations.of(context)!.spanish),
            onTap: () {
              context
                  .read<LanguageBloc>()
                  .add(ChangeLanguageEvent(const Locale('es')));
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            leading: const Icon(Icons.flag, color: Colors.blueAccent),
            title:  Text(AppLocalizations.of(context)!.french),
            onTap: () {
              context
                  .read<LanguageBloc>()
                  .add(ChangeLanguageEvent(const Locale('fr')));
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            leading: const Icon(Icons.flag, color: Colors.orange),
            title:  Text(AppLocalizations.of(context)!.catalan),
            onTap: () {
              context
                  .read<LanguageBloc>()
                  .add(ChangeLanguageEvent(const Locale('ca')));
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}