import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/admin/admin_user_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/admin/admin_user_event.dart';
import 'package:roll_and_reserve/presentation/blocs/admin/admin_user_state.dart';
import 'package:roll_and_reserve/presentation/blocs/login/login_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/login/login_state.dart';
import 'package:roll_and_reserve/presentation/blocs/shops/shop_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/shops/shop_event.dart';
import 'package:roll_and_reserve/presentation/blocs/shops/shop_state.dart';
import 'package:roll_and_reserve/core/services/notification_service.dart';
import 'package:roll_and_reserve/presentation/functions/state_check.dart';
import 'package:roll_and_reserve/presentation/widgets/screen_components/screen_body/body_admin_shops.dart';
import 'package:roll_and_reserve/presentation/widgets/screen_components/default_scaffold.dart';
import 'package:roll_and_reserve/l10n/app_localizations.dart';
import 'package:roll_and_reserve/presentation/widgets/screen_components/screen_body/body_users_admin.dart';

class ScreenAdmin extends StatefulWidget {
  final PreferredSizeWidget appBar;
  const ScreenAdmin({super.key, required this.appBar});

  @override
  State<ScreenAdmin> createState() => _ScreenAdminState();
}

class _ScreenAdminState extends State<ScreenAdmin> {
  int currentIndex = 0;

  @override

  /// Initialize the state of the widget.
  ///
  /// This function is called when the widget is inserted into the tree.
  ///
  /// It requests the Firebase token and fetches all users and shops.
  void initState() {
    super.initState();
    NotificationService().getToken();
    context.read<AdminUserBloc>().add(const GetAdminAllUsersEvent());
    context.read<ShopBloc>().add(GetShopsEvent());
  }

  @override

  /// Builds the main UI of the admin screen with a `BlocBuilder` for `LoginBloc` to handle
  /// user login state and a `BlocBuilder` for `ShopBloc` to handle shop state.
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, loginState) {
        return buildContent<LoginState>(
          state: loginState,
          isLoading: (state) => state.isLoading,
          errorMessage: (state) => state.errorMessage,
          hasData: (state) => state.user != null,
          context: context,
          contentBuilder: (state) {
            return DefaultScaffold(
              appBar: widget.appBar,
              body: currentIndex == 0
                  ? BlocBuilder<AdminUserBloc, AdminUserState>(
                      builder: (context, adminState) {
                        return buildContent<AdminUserState>(
                          state: adminState,
                          isLoading: (state) => state.isLoading,
                          errorMessage: (state) => state.errorMessage,
                          hasData: (state) => state.users != null,
                          context: context,
                          contentBuilder: (adminDataState) {
                            return Column(
                              children: [
                                BodyUsersAdmin(users: adminDataState.users),
                              ],
                            );
                          },
                        );
                      },
                    )
                  : BlocBuilder<ShopBloc, ShopState>(
                      builder: (context, state) {
                        return buildContent<ShopState>(
                          state: state,
                          isLoading: (state) => state.isLoading,
                          errorMessage: (state) => state.errorMessage,
                          hasData: (state) => state.shops != null,
                          context: context,
                          contentBuilder: (state) {
                            return const BodyAdminShops();
                          },
                        );
                      },
                    ),
              floatingActionButton: Container(),
              bottomNavigationBar: BottomNavigationBar(
                items: [
                  BottomNavigationBarItem(
                    icon: const Icon(Icons.people),
                    label: AppLocalizations.of(context)!.username,
                  ),
                  BottomNavigationBarItem(
                    icon: const Icon(Icons.store),
                    label: AppLocalizations.of(context)!.edit_shop,
                  ),
                ],
                onTap: (index) {
                  setState(() {
                    currentIndex = index;
                  });
                },
                currentIndex: currentIndex,
              ),
            );
          },
        );
      },
    );
  }
}
