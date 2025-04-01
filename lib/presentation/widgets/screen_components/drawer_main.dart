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

  Widget _buildChatSubmenu(BuildContext context, ThemeData theme) {
    return ExpansionTile(
      leading: Icon(Icons.chat, color: theme.colorScheme.primary),
      title: Text(AppLocalizations.of(context)!.chat_features),
      children: [
        ListTile(
          leading: Icon(Icons.menu_book, color: theme.colorScheme.primary),
          title: Text(AppLocalizations.of(context)!.ask_about_rules),
          onTap: () => _navigateTo(context, '/user/chat'),
        ),
        ListTile(
          leading: Icon(Icons.theaters, color: theme.colorScheme.primary),
          title: Text(AppLocalizations.of(context)!.play_role_with_ai),
          onTap: () => _navigateTo(context, '/user/rolChat'),
        ),
        ListTile(
          leading: Icon(Icons.casino, color: theme.colorScheme.primary),
          title: Text(AppLocalizations.of(context)!.identify_board_games),
          onTap: () => _navigateTo(context, '/user/chatGemini'),
        ),
           ListTile(
          leading: Icon(Icons.castle, color: theme.colorScheme.primary),
          title: Text(AppLocalizations.of(context)!.game_vision_ai),
          onTap: () => _navigateTo(context, '/user/chatAssistant'),
        ),
      ],
    );
  }

  Widget _buildUserSubmenu(BuildContext context, ThemeData theme) {
    
    return ExpansionTile(
      leading: Icon(Icons.person, color: theme.colorScheme.primary),
      title: Text(AppLocalizations.of(context)!.user_management),
      children: [
        ListTile(
          leading: Icon(Icons.reviews, color: theme.colorScheme.primary),
          title: Text(AppLocalizations.of(context)!.received_reviews),
          onTap: () => _navigateToReviewScreen(context),
        ),
        ListTile(
          leading: Icon(Icons.qr_code, color: theme.colorScheme.primary),
          title: Text(AppLocalizations.of(context)!.your_reservations),
          onTap: () => _navigateTo(context, '/user/userReserves'),
        ),
        ListTile(
          leading: Icon(Icons.people, color: theme.colorScheme.primary),
          title: Text(AppLocalizations.of(context)!.latest_players),
          onTap: () => _navigateTo(context, '/user/lastUsers'),
        ),
      ],
    );
  }

  Widget _buildSettingsSubmenu(BuildContext context, ThemeData theme) {
    return ExpansionTile(
      leading: Icon(Icons.settings, color: theme.colorScheme.primary),
      title: Text(AppLocalizations.of(context)!.settings),
      children: [
        ListTile(
          leading: Icon(Icons.edit, color: theme.colorScheme.primary),
          title: Text(AppLocalizations.of(context)!.profile_settings),
          onTap: () => _showUserEdit(context),
        ),
        ListTile(
          leading: Icon(Icons.lock, color: theme.colorScheme.primary),
          title: Text(AppLocalizations.of(context)!.change_password),
          onTap: () => _updatePassword(context),
        ),
        ListTile(
          leading: Icon(Icons.translate, color: theme.colorScheme.primary),
          title: Text(AppLocalizations.of(context)!.changeLanguage),
          onTap: () => _changeLanguage(context),
        ),
      ],
    );
  }

  void _navigateTo(BuildContext context, String route) {
    Navigator.pop(context);
    context.go(route);
  }

  void _navigateToReviewScreen(BuildContext context) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, _, __) => ScreenReviewUser(appBar: appBar),
        transitionDuration: Duration.zero,
      ),
    );
  }

  void _showUserEdit(BuildContext context) {
    Navigator.pop(context);
    mostrarUserEdit(context);
  }

  void _updatePassword(BuildContext context) {
    Navigator.pop(context);
    updatePassword(context);
  }

  void _changeLanguage(BuildContext context) {
    Navigator.pop(context);
    changeLanguage(context);
  }

  @override
  Widget build(BuildContext context) {
    final userBloc = BlocProvider.of<LoginBloc>(context);
    final theme = Theme.of(context);
    final user = userBloc.state.user;

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
              user?.username ?? AppLocalizations.of(context)!.username,
              style: TextStyle(fontSize: 20),
            ),
            accountEmail: Text(user?.email ?? 'email@example.com'),
            currentAccountPicture: CircleAvatar(
              backgroundImage: kIsWeb
                  ? MemoryImage(user!.avatar!)
                  : FileImage(File(user!.avatar.path)),
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                user.role == 0
                    ? ListTile(
                        leading: Icon(Icons.admin_panel_settings,
                            color: theme.colorScheme.primary),
                        title: Text(AppLocalizations.of(context)!.role_admin),
                        onTap: () => _navigateTo(context, '/user'),
                      )
                    : ListTile(
                        leading: Icon(Icons.home,
                            color: theme.colorScheme.primary),
                        title: Text(AppLocalizations.of(context)!.home),
                        onTap: () => _navigateTo(context, '/user'),
                      ),

                _buildChatSubmenu(context, theme),

                if (user.role == 2) _buildUserSubmenu(context, theme),

                if (user.role != 2 && user.role != 0)
                  ListTile(
                    leading: Icon(Icons.bar_chart,
                        color: theme.colorScheme.primary),
                    title: Text(
                        AppLocalizations.of(context)!.store_statistics),
                    onTap: () => _navigateTo(context, '/user/stadistics'),
                  ),

                // Settings
                _buildSettingsSubmenu(context, theme),
              ],
            ),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.exit_to_app, color: Colors.red),
            title: Text(AppLocalizations.of(context)!.logout,
                style: TextStyle(color: Colors.red)),
            onTap: () => mostrarLogOut(context),
          ),
          SizedBox(height: 16),
        ],
      ),
    );
  }
}