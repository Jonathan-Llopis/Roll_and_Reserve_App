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

  /// Builds the chat features submenu.
  ///
  /// This submenu is used to navigate to the different chat features of the
  /// app. It shows four options: "Ask AI about rules", "Play role with AI",
  /// "Identify board games", and "Game vision AI". When the user taps on one
  /// of these options, the corresponding screen is shown.
  ///
  /// The menu is an [ExpansionTile] widget that shows the title "Chat features"
  /// and has the chat icon. The children of the tile are four [ListTile]
  /// widgets, one for each of the options mentioned above. The leading of
  /// each tile is an icon, and the title is the text that describes the
  /// option. The onTap callback of each tile is a function that navigates to
  /// the corresponding screen.
  ///
  /// The theme is used to style the menu. The color of the icons is the
  /// primary color of the theme, and the text color is the onSurface color
  /// of the theme.
  ///
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

  /// Builds the user submenu.
  ///
  /// This submenu is used to navigate to the different user features of the
  /// app. It shows three options: "Received reviews", "Your reservations", and
  /// "Latest players". When the user taps on one of these options, the corresponding
  /// screen is shown.
  ///
  /// The menu is an [ExpansionTile] widget that shows the title "User management"
  /// and has the person icon. The children of the tile are three [ListTile]
  /// widgets, one for each of the options mentioned above. The leading of
  /// each tile is an icon, and the title is the text that describes the
  /// option. The onTap callback of each tile is a function that navigates to
  /// the corresponding screen.
  ///
  /// The theme is used to style the menu. The color of the icons is the
  /// primary color of the theme, and the text color is the onSurface color
  /// of the theme.
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

  /// Builds the settings submenu.
  ///
  /// This submenu is used to navigate to the different settings screens of the
  /// app. It shows three options: "Profile settings", "Change password", and
  /// "Change language". When the user taps on one of these options, the corresponding
  /// screen is shown.
  ///
  /// The menu is an [ExpansionTile] widget that shows the title "Settings"
  /// and has the settings icon. The children of the tile are three [ListTile]
  /// widgets, one for each of the options mentioned above. The leading of
  /// each tile is an icon, and the title is the text that describes the
  /// option. The onTap callback of each tile is a function that navigates to
  /// the corresponding screen or shows a dialog to change the language.
  ///
  /// The theme is used to style the menu. The color of the icons is the
  /// primary color of the theme, and the text color is the onSurface color
  /// of the theme.
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

  /// Navigates to the given route and pops the current context.
  ///
  /// This is a helper function used to navigate to different screens
  /// in the app. It takes the current BuildContext and the route
  /// to navigate to as parameters. It pops the current context
  /// and then navigates to the given route.
  void _navigateTo(BuildContext context, String route) {
    Navigator.pop(context);
    context.go(route);
  }

  /// Navigates to the user's reviews screen.
  ///
  /// This is a helper function that navigates to the user's reviews
  /// screen. It takes the current BuildContext as a parameter.
  /// It uses the PageRouteBuilder to build the route, and sets the
  /// transition duration to zero so that the navigation happens
  /// immediately. It then pushes the route to the navigator.
  void _navigateToReviewScreen(BuildContext context) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, _, __) => ScreenReviewUser(appBar: appBar),
        transitionDuration: Duration.zero,
      ),
    );
  }

  /// Closes the current context and shows the user edit dialog.
  ///
  /// This method is called to display the user edit dialog by popping
  /// the current screen and then calling [mostrarUserEdit] to show the dialog.
  /// It takes the current [BuildContext] as a parameter.

  void _showUserEdit(BuildContext context) {
    Navigator.pop(context);
    mostrarUserEdit(context);
  }

  void _updatePassword(BuildContext context) {
    Navigator.pop(context);
  /// Closes the current context and invokes the password update process.
  ///
  /// This method is used to handle password updates by first closing the 
  /// current dialog or screen and then calling [updatePassword] to initiate 
  /// the process. It takes the current [BuildContext] as a parameter.

    updatePassword(context);
  }

  /// Closes the current context and shows the language change dialog.
  ///
  /// This method is used to handle language changes by first closing the 
  /// current dialog or screen and then calling [changeLanguage] to show the 
  /// dialog. It takes the current [BuildContext] as a parameter.
  void _changeLanguage(BuildContext context) {
    Navigator.pop(context);
    changeLanguage(context);
  }

  @override
  /// Builds the main drawer of the app.
  ///
  /// This is a main drawer for the app that is displayed when the user
  /// taps on the hamburger button in the appbar. It shows the user's
  /// profile picture, username, and email. It also shows a list of
  /// items that the user can navigate to. The items are different
  /// depending on the role of the user. If the user is an admin, the
  /// drawer shows a link to the administrator's panel. If the user
  /// is a store owner, the drawer shows a link to the store's statistics.
  /// If the user is a normal user, the drawer shows a link to the user's
  /// profile and the user's reservations. All users can navigate to
  /// the chat features, the settings, and the logout.
  ///
  /// The drawer is a [Column] with a [UserAccountsDrawerHeader] as its
  /// first child. The header shows the user's profile picture, username,
  /// and email. The column's children are a [ListView] with the list of
  /// items that the user can navigate to, and a [ListTile] with the logout
  /// option. The [ListView] is an [Expanded] child of the column, so that
  /// it takes all the available space. The logout [ListTile] is at the
  /// bottom of the column, and has a red color to indicate that it is a
  /// destructive action.
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