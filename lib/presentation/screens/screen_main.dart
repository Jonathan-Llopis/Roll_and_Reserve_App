import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:roll_and_reserve/presentation/blocs/login/login_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/login/login_event.dart';
import 'package:roll_and_reserve/presentation/blocs/login/login_state.dart';
import 'package:roll_and_reserve/presentation/blocs/shops/shop_bloc.dart';
import 'package:roll_and_reserve/presentation/functions/state_check.dart';
import 'package:roll_and_reserve/presentation/widgets/screen_components/bottom_filter_shops.dart';
import 'package:roll_and_reserve/presentation/widgets/screen_components/screen_body/body_main_shops.dart';
import 'package:roll_and_reserve/presentation/widgets/screen_components/default_scaffold.dart';

class ScreenMain extends StatefulWidget {
  const ScreenMain({super.key});

  @override
  State<ScreenMain> createState() => _ScreenMainState();
}

class _ScreenMainState extends State<ScreenMain> {
  @override
  @override
  void initState() {
    super.initState();
    BlocProvider.of<LoginBloc>(context).add(CheckAuthentication());
    
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
      return buildContent<LoginState>(
          state: state,
          isLoading: (state) => state.isLoading,
          errorMessage: (state) => state.errorMessage,
          hasData: (state) => state.user != null,
          contentBuilder: (state) {
            return DefaultScaffold(
                body: BodyMain(),
                floatingActionButton: state.user!.role == 1
                    ? FloatingActionButton(
                        onPressed: () {
                          context.go('/user/shop_edit/${0}');
                        },
                        child: const Icon(Icons.add),
                      )
                    : null,
                bottomNavigationBar:
                    state.user!.role == 2 ? BottomFilterShops(shopBloc: context.read<ShopBloc>(),) : null);
          });
    });
  }
}
