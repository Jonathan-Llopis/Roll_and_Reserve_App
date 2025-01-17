import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:roll_and_reserve/presentation/functions/functions_show_dialogs.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DrawerLogin extends StatelessWidget {
  const DrawerLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/appbar_back.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            accountName: Text(
              'Roll and Reserve',
              style: TextStyle(fontSize: 20),
            ),
            accountEmail: Text(
              AppLocalizations.of(context)!.find_your_game_table,
            ),
            currentAccountPicture: CircleAvatar(
              backgroundImage: AssetImage('/assets/images/logo.png'),
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                ListTile(
                  leading: Icon(Icons.person, color: Colors.lightBlue),
                  title: Text(AppLocalizations.of(context)!.login),
                  onTap: () {
                    context.go('/login');
                  },
                ),
                ListTile(
                  leading: Icon(Icons.person_add, color: Colors.lightBlue),
                  title: Text(AppLocalizations.of(context)!.register),
                  onTap: () {
                    context.go('/login/signIn');
                  },
                ),
                ListTile(
                  leading: Icon(Icons.translate, color: Colors.lightBlue),
                  title: Text(AppLocalizations.of(context)!.changeLanguage),
                  onTap: () {
                    changeLanguage(context);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
