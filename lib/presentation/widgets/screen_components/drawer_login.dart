import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:roll_and_reserve/presentation/functions/functions_show_dialogs.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DrawerLogin extends StatelessWidget {
  const DrawerLogin({super.key});

  @override
  /// Builds a drawer widget containing user account information and navigation
  /// options.
  ///
  /// The drawer includes a header with an image, account name, and account
  /// email. It also features a list of navigation options such as login,
  /// registration, and language change. Each list tile has an icon and text,
  /// and navigates to a different route when tapped.
  ///
  /// - Parameters:
  ///   - context: The BuildContext to access theme and localization resources.
  ///
  /// - Returns: A Drawer widget with user account header and navigation
  ///   options.

  Widget build(BuildContext context) {
      final theme = Theme.of(context);
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
              backgroundImage: AssetImage('assets/icon/logo.png'),
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                ListTile(
                  leading: Icon(Icons.person, color: theme.colorScheme.primary),
                  title: Text(AppLocalizations.of(context)!.login),
                  onTap: () {
                    context.go('/login');
                  },
                ),
                ListTile(
                  leading: Icon(Icons.person_add, color: theme.colorScheme.primary),
                  title: Text(AppLocalizations.of(context)!.register),
                  onTap: () {
                    context.go('/login/signIn');
                  },
                ),
                ListTile(
                  leading: Icon(Icons.translate, color: theme.colorScheme.primary),
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
