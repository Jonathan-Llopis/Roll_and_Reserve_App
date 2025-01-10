import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:roll_and_reserve/presentation/blocs/login/login_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/login/login_state.dart';
import 'package:roll_and_reserve/presentation/blocs/shops/shop_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/shops/shop_event.dart';

class DialogDeleteShop extends StatelessWidget {
  final int idShop;
  const DialogDeleteShop({super.key, required this.idShop});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
      return AlertDialog(
        title: const Text("Eliminar Tienda", style: TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontSize: 30,)),
        content: const Text(
          '¿Estas seguro que quieres eliminar la tienda?',
          style: TextStyle(
            fontSize: 18,
            color: Color.fromARGB(255, 0, 0, 0),
          ),
        ),
        actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancelar'),
          ),
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              context.read<ShopBloc>().add(DeleteShopEvent(idShop: idShop, idOwner: state.user!.id, ));
              context.go('/user');
            },
            child: const Text('Aceptar'),
          ),
        ],
      );
    });
  }
}