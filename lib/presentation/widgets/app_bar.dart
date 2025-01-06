import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/auth/login_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/auth/login_event.dart';
import 'package:roll_and_reserve/presentation/blocs/auth/login_state.dart';

class AppBarDefault extends StatelessWidget implements PreferredSizeWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  const AppBarDefault(
      {super.key, required this.scaffoldKey,});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
      context.read<LoginBloc>().add(CheckAuthentication());
      if (state.user == null) {
        return const Center(child: CircularProgressIndicator());
      } else {
        return AppBar(
          title: Row(
            children: [
              Image.asset(
                'assets/icon/logo.png',
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
              const Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Incidencies',
                      style: TextStyle(fontSize: 20),
                    ),
                    Text(
                      "IES l'Estació",
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                scaffoldKey.currentState?.openEndDrawer();
              },
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(16),
              ),
              child:  Text("User"),
            //   child:  CircleAvatar(
            //   backgroundImage: kIsWeb
            //       ? MemoryImage(state.user!.avatar!)
            //       : FileImage(File(state.user!.avatar.path)),
            // ),
            ),
          ],
        );
      }
    });
  }
}