import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/auth/login_bloc.dart';
import 'package:roll_and_reserve/presentation/functions/show_dialogs.dart';

class MenuLateral extends StatelessWidget {
  const MenuLateral({super.key});

  @override
  Widget build(BuildContext context) {
    final userBloc = BlocProvider.of<LoginBloc>(context);
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Material(
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).padding.top, bottom: 24),
                      child: Column(
                        children: [
                          const CircleAvatar(
                            radius: 52,
                            backgroundImage: NetworkImage(
                                "https://media.istockphoto.com/id/1300845620/vector/user-icon-flat-isolated-on-white-background-user-symbol-vector-illustration.jpg?s=612x612&w=0&k=20&c=yBeyba0hUkh14_jgv1OKqIH0CCSWU_4ckRkAoy2p73o="),
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          Text(
                            userBloc.state.user!.name,
                            style: const TextStyle(
                                fontSize: 28, color: Colors.white),
                          ),
                          Text(
                            userBloc.state.user!.email,
                            style: const TextStyle(
                                fontSize: 14, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            contentPadding: const EdgeInsets.only(bottom: 16),
            title: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Cerrar Sesión',
                  style: TextStyle(color: Colors.white),
                ),
                Icon(
                  Icons.exit_to_app,
                  color: Colors.white,
                ),
              ],
            ),
            onTap: () {
              mostrarLogOut(context);
            },
          ),
        ],
      ),
    );
  }
}
