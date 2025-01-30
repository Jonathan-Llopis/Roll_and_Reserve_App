import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:roll_and_reserve/presentation/blocs/login/login_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/reserve/reserve_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/reserve/reserve_event.dart';
import 'package:roll_and_reserve/presentation/blocs/reserve/reserve_state.dart';
import 'package:roll_and_reserve/presentation/functions/state_check.dart';
import 'package:roll_and_reserve/presentation/widgets/screen_components/default_scaffold.dart';
import 'package:roll_and_reserve/presentation/widgets/screen_components/screen_body/body_events.dart';

class ScreenShopEvents extends StatefulWidget {
  final int idShop;
  const ScreenShopEvents({super.key, required this.idShop});

  @override
  State<ScreenShopEvents> createState() => _ScreenShopEventsState();
}

class _ScreenShopEventsState extends State<ScreenShopEvents> {
  @override
  void initState() {
    context.read<ReserveBloc>().add(
          GetEventsEvent(idShop: widget.idShop),
        );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    LoginBloc loginBloc = BlocProvider.of<LoginBloc>(context);
    return BlocBuilder<ReserveBloc, ReserveState>(builder: (context, state) {
      return buildContent<ReserveState>(
          state: state,
          isLoading: (state) => state.isLoading,
          errorMessage: (state) => state.errorMessage,
          hasData: (state) => state.eventsShop != null,
          contentBuilder: (state) {
            return DefaultScaffold(
              body: BodyEvents(
                events: state.eventsShop!,
                idShop: widget.idShop,
              ),
              floatingActionButton:   loginBloc.state.user!.role == 1
                    ? FloatingActionButton(
                onPressed: () {
                  context.go('/user/events/${widget.idShop}/createEvent');
                },
                child: Icon(Icons.add),
              ) : null
            );
          });
    });
  }
}
