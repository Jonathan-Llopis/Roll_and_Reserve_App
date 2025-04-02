import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:roll_and_reserve/presentation/blocs/login/login_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/login/login_event.dart';
import 'package:roll_and_reserve/presentation/blocs/login/login_state.dart';
import 'package:roll_and_reserve/presentation/blocs/shops/shop_bloc.dart';
import 'package:roll_and_reserve/presentation/functions/notification_service.dart';
import 'package:roll_and_reserve/presentation/functions/state_check.dart';
import 'package:roll_and_reserve/presentation/widgets/screen_components/bottom_filter_shops.dart';
import 'package:roll_and_reserve/presentation/widgets/screen_components/screen_body/body_main_shops.dart';
import 'package:roll_and_reserve/presentation/widgets/screen_components/default_scaffold.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ScreenMain extends StatefulWidget {
  final PreferredSizeWidget appBar;
  const ScreenMain({super.key, required this.appBar});

  @override
  State<ScreenMain> createState() => _ScreenMainState();
}

class _ScreenMainState extends State<ScreenMain> {
  @override
  /// Initializes the state of the main screen.
  ///
  /// This method is called when the widget is inserted into the widget tree.
  /// It retrieves the notification token using [NotificationService] and
  /// triggers an authentication check by dispatching the [CheckAuthentication]
  /// event to the [LoginBloc].

  void initState() {
    super.initState();
    NotificationService().getToken();
    BlocProvider.of<LoginBloc>(context).add(CheckAuthentication());

  }

  @override
  /// This method builds the main screen widget.
  ///
  /// This widget is a [BlocBuilder] of the [LoginBloc].
  /// It displays a [DefaultScaffold] with a [BodyMain] as the body.
  /// The bottom navigation bar is a [BottomFilterShops] if the user is user, null otherwise.
  /// The floating action button is a [FloatingActionButton] that leads to the shop creation
  /// screen if the user is an admin, or to the shop map screen if the user is a shop.
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
                body: BodyMain(),
                floatingActionButton: state.user!.role == 1
                    ? FloatingActionButton(
                        onPressed: () {
                          context.go('/user/shop_edit/${0}');
                        },
                        child: const Icon(Icons.add),
                      )
                    : FloatingActionButton(
                        onPressed: () {
                          context.go('/user/map');
                        },
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.map_sharp),
                              Text(AppLocalizations.of(context)!.store_map,
                                  style: TextStyle(fontSize: 10), textAlign: TextAlign.center,),
                            ],
                          ),
                      ),
                bottomNavigationBar: state.user!.role == 2
                    ? BottomFilterShops(
                        shopBloc: context.read<ShopBloc>(),
                      )
                    : null);
                    
          });
    });
  }
}
