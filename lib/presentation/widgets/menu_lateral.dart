import 'dart:io';

import 'package:flutter/foundation.dart';
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
        children: [
          // Encabezado del Drawer
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              color: Colors.lightBlue.shade700,
            ),
            accountName: Text(
              userBloc.state.user?.username ?? 'Usuario',
              style: TextStyle(fontSize: 20),
            ),
            accountEmail: Text(
              userBloc.state.user?.email ?? 'correo@example.com',
            ),
            currentAccountPicture: CircleAvatar(
              backgroundImage: kIsWeb
                  ? MemoryImage(userBloc.state.user!.avatar!)
                  : FileImage(File(userBloc.state.user!.avatar.path)),
            ),
          ),

          // Opciones del menú
          Expanded(
            child: ListView(
              children: [
                ListTile(
                  leading: Icon(Icons.home, color: Colors.lightBlue),
                  title: Text('Inicio'),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.settings, color: Colors.lightBlue),
                  title: Text('Configuración'),
                  onTap: () {
                    mostrarUserEdit(context);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.lock, color: Colors.lightBlue),
                  title: Text('Cambiar Contraseña'),
                  onTap: () {
                    updatePassword(context);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.help, color: Colors.lightBlue),
                  title: Text('Ayuda'),
                  onTap: () {},
                ),
              ],
            ),
          ),

          // Botón de Cerrar Sesión
          Divider(),
          ListTile(
            leading: Icon(Icons.exit_to_app, color: Colors.red),
            title: Text(
              'Cerrar Sesión',
              style: TextStyle(color: Colors.red),
            ),
            onTap: () {
              mostrarLogOut(context);
            },
          ),
          SizedBox(height: 16),
        ],
      ),
    );
  }
}
