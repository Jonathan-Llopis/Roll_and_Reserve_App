import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:roll_and_reserve/presentation/blocs/login/login_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/reserve/reserve_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/reserve/reserve_event.dart';
import 'package:roll_and_reserve/presentation/blocs/reserve/reserve_state.dart';
import 'package:roll_and_reserve/presentation/blocs/tables/table_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/tables/table_event.dart';
import 'package:roll_and_reserve/presentation/functions/state_check.dart';
import 'package:roll_and_reserve/presentation/widgets/screen_components/default_scaffold.dart';
import 'package:roll_and_reserve/presentation/widgets/screen_components/screen_body/body_events.dart';

class ScreenShopEvents extends StatefulWidget {
  final int idShop;

  final PreferredSizeWidget appBar;
  const ScreenShopEvents(
      {super.key, required this.idShop, required this.appBar});

  @override
  State<ScreenShopEvents> createState() => _ScreenShopEventsState();
}

class _ScreenShopEventsState extends State<ScreenShopEvents> {
  @override
  /// Called when the widget is inserted into the tree.
  ///
  /// This method is responsible for requesting the events of the shop with the given
  /// idShop from the database and requesting the tables from the database.
  void initState() {
    context.read<ReserveBloc>().add(
          GetEventsEvent(idShop: widget.idShop),
        );
    context.read<TableBloc>().add(
          GetTablesEvent(),
        );
    super.initState();
  }

  @override
  /// Builds the UI for [ScreenShopEvents].
  ///
  /// This uses the [ReserveBloc] to manage the state of the events of the shop.
  /// The [ReserveState] is used to determine if the state is loading,
  /// if there is an error, and if there is data.
  ///
  /// If the state is loading, it shows a [CircularProgressIndicator].
  /// If there is an error, it shows an error message.
  /// If there is data, it shows a [DefaultScaffold] with a [BodyEvents] with the events
  /// and the given [appBar].
  ///
  /// If the user is an administrator, the floating action button is a [FloatingActionButton]
  /// that leads to the event creation screen.
  /// Otherwise, the floating action button is null.
  Widget build(BuildContext context) {
    LoginBloc loginBloc = BlocProvider.of<LoginBloc>(context);
    return BlocBuilder<ReserveBloc, ReserveState>(builder: (context, state) {
      return buildContent<ReserveState>(
          state: state,
          isLoading: (state) => state.isLoading,
          errorMessage: (state) => state.errorMessage,
          hasData: (state) => state.eventsShop != null,
          context: context,
          contentBuilder: (state) {
            return DefaultScaffold(
                appBar: widget.appBar,
                body: BodyEvents(
                  events: state.eventsShop!,
                  idShop: widget.idShop,
                ),
                floatingActionButton: loginBloc.state.user!.role == 1
                    ? FloatingActionButton(
                        onPressed: () {
                          context
                              .go('/user/events/${widget.idShop}/createEvent');
                        },
                        child: Icon(Icons.add),
                      )
                    : null);
          });
    });
  }
}
