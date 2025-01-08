import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:roll_and_reserve/presentation/blocs/auth/login_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/auth/login_event.dart';
import 'package:roll_and_reserve/presentation/blocs/auth/login_state.dart';
import 'package:roll_and_reserve/presentation/widgets/app_bar.dart';
import 'package:roll_and_reserve/presentation/widgets/body_users/shop_body.dart';
import 'package:roll_and_reserve/presentation/widgets/menu_lateral.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
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
          appBar: AppBarDefault(
            scaffoldKey: scaffoldKey,
          ),
          body: const ShopsBody(),
          endDrawer: const MenuLateral(),
          floatingActionButton: state.user!.role == 1
              ? FloatingActionButton(
                  onPressed: () {
                     context.go('/user/shop_edit/${0}');
                  },
                  child: const Icon(Icons.add),
                )
              : null,
        );
      }

      return Container();
    });
  }
}
