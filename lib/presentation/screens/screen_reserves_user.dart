import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/login/login_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/reserve/reserve_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/reserve/reserve_event.dart';
import 'package:roll_and_reserve/presentation/blocs/reserve/reserve_state.dart';
import 'package:roll_and_reserve/presentation/functions/state_check.dart';
import 'package:roll_and_reserve/presentation/widgets/screen_components/default_scaffold.dart';
import 'package:roll_and_reserve/presentation/widgets/screen_components/screen_body/body_reserves_user.dart';

class ScreenReservesOfUser extends StatefulWidget {
  final PreferredSizeWidget appBar;
  const ScreenReservesOfUser({super.key, required this.appBar});

  @override
  State<ScreenReservesOfUser> createState() => _ScreenReservesOfUserState();
}

class _ScreenReservesOfUserState extends State<ScreenReservesOfUser> {
  @override
  void initState() {
    LoginBloc loginBloc = BlocProvider.of<LoginBloc>(context);
    context.read<ReserveBloc>().add(
          GetReservesByUserEvent(idUser: loginBloc.state.user!.id),
        );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReserveBloc, ReserveState>(builder: (context, state) {
      return buildContent<ReserveState>(
          state: state,
          isLoading: (state) => state.isLoading,
          errorMessage: (state) => state.errorMessage,
          hasData: (state) => state.reservesOfUser != null,
          context: context,
          contentBuilder: (state) {
            return DefaultScaffold(
              appBar: widget.appBar,
              body: BodyReservesUser(
                reserves: state.reservesOfUser!,
                appBar: widget.appBar,
              ),
            );
          });
    });
  }
}
