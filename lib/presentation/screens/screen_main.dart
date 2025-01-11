import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:roll_and_reserve/presentation/blocs/login/login_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/login/login_event.dart';
import 'package:roll_and_reserve/presentation/blocs/login/login_state.dart';
import 'package:roll_and_reserve/presentation/widgets/screen_components/bottom_filter_shops.dart';
import 'package:roll_and_reserve/presentation/widgets/screen_components/default_app_bar.dart';
import 'package:roll_and_reserve/presentation/widgets/screen_components/body_main_shops.dart';
import 'package:roll_and_reserve/presentation/widgets/screen_components/drawer_main.dart';


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
    var scaffoldKey = GlobalKey<ScaffoldState>();
    return BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
      if (state.isLoading) {
        return const Center(child: CircularProgressIndicator());
      } else if (state.errorMessage != null) {
        return Center(child: Text(state.errorMessage!));
      } else if (state.user != null) {
        return Scaffold(
          key: scaffoldKey,
          appBar: DefaultAppBar(
            scaffoldKey: scaffoldKey,

          ),
          body: const BodyMain(),
          endDrawer: const DrawerMain(),
          floatingActionButton: state.user!.role == 1
              ? FloatingActionButton(
                  onPressed: () {
                    context.go('/user/shop_edit/${0}');
                  },
                  child: const Icon(Icons.add),
                )
              : null,
          bottomNavigationBar: state.user!.role == 2 ? BottomFilterShops() : null
        );
      }

      return Container();
    });
  }
}
