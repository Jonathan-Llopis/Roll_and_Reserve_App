import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:roll_and_reserve/presentation/blocs/login/login_bloc.dart';
import 'package:roll_and_reserve/presentation/functions/functions_show_dialogs.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:roll_and_reserve/presentation/screens/screen_review_user.dart';

class DrawerMain extends StatelessWidget {
  const DrawerMain({super.key, required this.appBar});
  final PreferredSizeWidget appBar;

  @override
  Widget build(BuildContext context) {
    final userBloc = BlocProvider.of<LoginBloc>(context);

    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation1, animation2) =>
                      ScreenReviewUser(
                    appBar: appBar,
                  ),
                  transitionDuration: Duration.zero,
                  reverseTransitionDuration: Duration.zero,
                ),
              );
            },
            child: UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/appbar_back.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              accountName: Text(
                userBloc.state.user?.username ??
                    AppLocalizations.of(context)!.username,
                style: TextStyle(fontSize: 20),
              ),
              accountEmail: Text(
                userBloc.state.user?.email ?? 'email@example.com',
              ),
              currentAccountPicture: CircleAvatar(
                backgroundImage: kIsWeb
                    ? MemoryImage(userBloc.state.user!.avatar!)
                    : FileImage(File(userBloc.state.user!.avatar.path)),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                ListTile(
                  leading: Icon(Icons.home, color: Colors.lightBlue),
                  title: Text(AppLocalizations.of(context)!.home),
                  onTap: () {
                    Navigator.pop(context);
                    context.go('/user');
                  },
                ),
                userBloc.state.user!.role == 2
                    ? ListTile(
                        leading: Icon(Icons.qr_code, color: Colors.lightBlue),
                        title: Text(
                            AppLocalizations.of(context)!.your_reservations),
                        onTap: () {
                          Navigator.pop(context);
                          context.go('/user/userReserves');
                        },
                      )
                    : Container(),
                ListTile(
                  leading: Icon(Icons.settings, color: Colors.lightBlue),
                  title: Text(AppLocalizations.of(context)!.settings),
                  onTap: () {
                    Navigator.pop(context);
                    mostrarUserEdit(context);
                  },
                ),
                 userBloc.state.user!.role == 2
                    ? ListTile(
                  leading:
                      Icon(Icons.person_pin_sharp, color: Colors.lightBlue),
                  title: Text(AppLocalizations.of(context)!.latest_players),
                  onTap: () {
                    Navigator.pop(context);
                    context.go('/user/lastUsers');
                  },
                ) : ListTile(
                  leading:
                    Icon(Icons.bar_chart, color: Colors.lightBlue),
                  title: Text(AppLocalizations.of(context)!.store_statistics),
                  onTap: () {
                  Navigator.pop(context);
                  context.go('/user/stadistics');
                  },
                ),
                ListTile(
                  leading: Icon(Icons.lock, color: Colors.lightBlue),
                  title: Text(AppLocalizations.of(context)!.change_password),
                  onTap: () {
                    Navigator.pop(context);
                    updatePassword(context);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.translate, color: Colors.lightBlue),
                  title: Text(AppLocalizations.of(context)!.changeLanguage),
                  onTap: () {
                    Navigator.pop(context);
                    changeLanguage(context);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.help, color: Colors.lightBlue),
                  title: Text(AppLocalizations.of(context)!.help),
                  onTap: () {
                    Navigator.pop(context);
                    context.go('/user/chat');
                  },
                ),
              ],
            ),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.exit_to_app, color: Colors.red),
            title: Text(
              AppLocalizations.of(context)!.logout,
              style: TextStyle(color: Colors.red),
            ),
            onTap: () {
              mostrarLogOut(context);
            },
          ),
          SizedBox(height: 16),
        ],
      ),
    );
  }
}
