import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/login/login_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/reserve/reserve_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/reserve/reserve_event.dart';
import 'package:roll_and_reserve/presentation/blocs/reserve/reserve_state.dart';
import 'package:roll_and_reserve/presentation/blocs/tables/table_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/tables/table_event.dart';
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
/// Initializes the state of the widget when it is inserted into the tree.
///
/// This method retrieves the `LoginBloc` to access the current user's ID and
/// dispatches a `GetReservesByUserEvent` to the `ReserveBloc` to fetch the
/// user's reserves. Additionally, it dispatches a `GetTablesEvent` to the
/// `TableBloc` to retrieve the tables information. Finally, it calls the
/// superclass's `initState` method to ensure proper initialization.

  void initState() {
    LoginBloc loginBloc = BlocProvider.of<LoginBloc>(context);
    context.read<ReserveBloc>().add(
          GetReservesByUserEvent(idUser: loginBloc.state.user!.id),
        );
    context.read<TableBloc>().add(
          GetTablesEvent(),
        );
    context.read<TableBloc>().add(
          GetTablesEvent(),
        );
    super.initState();
  }

  @override
  /// Builds the UI for [ScreenReservesOfUser].
  ///
  /// This uses the [ReserveBloc] to manage the state of the reserves.
  /// The [ReserveState] is used to determine if the state is loading,
  /// if there is an error, and if there is data.
  ///
  /// If the state is loading, it shows a [CircularProgressIndicator].
  /// If there is an error, it shows an error message.
  /// If there is data, it shows a [BodyReservesUser] with the reserves and
  /// the given [appBar].
  Widget build(BuildContext context) {
    return DefaultScaffold(
      appBar: widget.appBar,
      body: BlocBuilder<ReserveBloc, ReserveState>(
        builder: (context, state) {
          return buildContent<ReserveState>(
            state: state,
            isLoading: (state) => state.isLoading,
            errorMessage: (state) => state.errorMessage,
            hasData: (state) => state.reservesOfUser != null,
            context: context,
            contentBuilder: (state) {
              return BodyReservesUser(
                reserves: state.reservesOfUser!,
                appBar: widget.appBar,
              );
            },
          );
        },
      ),
    );
  }
}
