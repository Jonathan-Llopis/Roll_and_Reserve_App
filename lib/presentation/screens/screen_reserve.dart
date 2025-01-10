import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:roll_and_reserve/domain/entities/reserve_entity.dart';
import 'package:roll_and_reserve/presentation/blocs/login/login_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/reserve/reserve_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/reserve/reserve_state.dart';
import 'package:roll_and_reserve/presentation/widgets/information/information_reserve.dart';

class GameReserveScreen extends StatefulWidget {
  final int idReserve;
  final int idShop;
  const GameReserveScreen({
    super.key,
    required this.idReserve,
    required this.idShop,
  });

  @override
  State<GameReserveScreen> createState() => _GameReserveScreenState();
}

class _GameReserveScreenState extends State<GameReserveScreen> {
  
  @override
  Widget build(BuildContext context) {
    LoginBloc loginBloc = BlocProvider.of<LoginBloc>(context);
    return BlocBuilder<ReserveBloc, ReserveState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (state.errorMessage != null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Error')),
            body: Center(child: Text(state.errorMessage!)),
          );
        } else if (state.reserves != null) {
          ReserveEntity reserve = state.reserves!
              .firstWhere((reserve) => reserve.id == widget.idReserve);
          return Scaffold(
            appBar: AppBar(
              title: Text("Mesa: ${reserve.tableId}"),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => context.go('/user/shop/table/${reserve.tableId}${widget.idShop}'),
              ),
            ),
            body: InformationReserve(widget: widget, reserve: reserve, loginBloc: loginBloc),
          );
        } else {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
      },
    );
  }
}
