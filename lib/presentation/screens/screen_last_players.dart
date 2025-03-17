import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/login/login_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/reserve/reserve_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/reserve/reserve_event.dart';
import 'package:roll_and_reserve/presentation/blocs/reserve/reserve_state.dart';
import 'package:roll_and_reserve/presentation/functions/state_check.dart';
import 'package:roll_and_reserve/presentation/widgets/screen_components/default_scaffold.dart';
import 'package:roll_and_reserve/presentation/widgets/screen_components/screen_body/body_last_players.dart';


class ScreenLastPlayers extends StatefulWidget {

  final PreferredSizeWidget appBar;
  const ScreenLastPlayers(
      {super.key, required this.appBar});

  @override
  State<ScreenLastPlayers> createState() => _ScreenLastPlayersState();
}

class _ScreenLastPlayersState extends State<ScreenLastPlayers> {
  @override
  void initState() {
    super.initState();
    ReserveBloc reserveBloc = BlocProvider.of<ReserveBloc>(context);
    LoginBloc loginBloc = BlocProvider.of<LoginBloc>(context);
    reserveBloc.add(GetLastTenPlayersEvent(idGoogle: loginBloc.state.user!.id));
  }

  @override
  Widget build(BuildContext context) {
 LoginBloc loginBloc = BlocProvider.of<LoginBloc>(context);
    return DefaultScaffold(
      appBar: widget.appBar,
      body: BlocBuilder<ReserveBloc, ReserveState>(
        builder: (context, state) {
          return buildContent<ReserveState>(
            state: state,
            isLoading: (state) => state.isLoading,
            errorMessage: (state) => state.errorMessage,
            hasData: (state) => state.lastUsers != null,
            context: context,
            contentBuilder: (state) {
              return BodyLastPlayers(
                  idUser: loginBloc.state.user!.id, users: state.lastUsers ?? [],);
            },
          );
        },
      ),
    );
  }
}
