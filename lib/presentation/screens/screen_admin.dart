import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/login/login_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/login/login_event.dart';
import 'package:roll_and_reserve/presentation/blocs/login/login_state.dart';
import 'package:roll_and_reserve/presentation/blocs/shops/shop_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/shops/shop_event.dart';
import 'package:roll_and_reserve/presentation/blocs/shops/shop_state.dart';
import 'package:roll_and_reserve/presentation/functions/notification_service.dart';
import 'package:roll_and_reserve/presentation/functions/state_check.dart';
import 'package:roll_and_reserve/presentation/widgets/screen_components/screen_body/body_admin_shops.dart';
import 'package:roll_and_reserve/presentation/widgets/screen_components/default_scaffold.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:roll_and_reserve/presentation/widgets/screen_components/screen_body/body_users_admin.dart';

class ScreenAdmin extends StatefulWidget {
  final PreferredSizeWidget appBar;
  const ScreenAdmin({super.key, required this.appBar});

  @override
  State<ScreenAdmin> createState() => _ScreenMainState();
}

class _ScreenMainState extends State<ScreenAdmin> {
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    NotificationService().getToken();
    context.read<LoginBloc>().add(GetAllUsersEvent());
    context.read<ShopBloc>().add(GetShopsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
      return buildContent<LoginState>(
          state: state,
          isLoading: (state) => state.isLoading,
          errorMessage: (state) => state.errorMessage,
          hasData: (state) => state.user != null,
          context: context,
          contentBuilder: (state) {
            return DefaultScaffold(
              appBar: widget.appBar,
              body: currentIndex == 0
                  ? BlocBuilder<LoginBloc, LoginState>(
                      builder: (context, state) {
                      return buildContent<LoginState>(
                        state: state,
                        isLoading: (state) => state.isLoading,
                        errorMessage: (state) => state.errorMessage,
                        hasData: (state) => state.users != null,
                        context: context,
                        contentBuilder: (state) {
                          return Column(
                            children: [
                              BodyUsersAdmin(),
                            ],
                          );
                        },
                      );
                    })
                  : BlocBuilder<ShopBloc, ShopState>(
                      builder: (context, state) {
                      return buildContent<ShopState>(
                        state: state,
                        isLoading: (state) => state.isLoading,
                        errorMessage: (state) => state.errorMessage,
                        hasData: (state) => state.shops != null,
                        context: context,
                        contentBuilder: (state) {
                          return BodyAdminShops();
                        },
                      );
                    }),
              floatingActionButton: Container(),
              bottomNavigationBar: BottomNavigationBar(
                items: [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.people),
                    label: AppLocalizations.of(context)!.username,
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.store),
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
          });
    });
  }
}
