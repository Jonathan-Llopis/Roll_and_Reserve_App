import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:roll_and_reserve/domain/entities/reserve_entity.dart';
import 'package:roll_and_reserve/presentation/blocs/login/login_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/login/login_event.dart';
import 'package:roll_and_reserve/presentation/blocs/login/login_state.dart';
import 'package:roll_and_reserve/presentation/functions/notification_service.dart';
import 'package:roll_and_reserve/presentation/functions/state_check.dart';
import 'package:roll_and_reserve/presentation/widgets/cards/card_reserve.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

DateTime? selectedDate;

class BodyEvents extends StatefulWidget {
  final List<ReserveEntity>? events;
  final int idShop;
  const BodyEvents({
    super.key,
    this.events,
    required this.idShop,
  });

  @override
  State<BodyEvents> createState() => _BodyEventsState();
}

class _BodyEventsState extends State<BodyEvents> {
  
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Store Events',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                  const SizedBox(height: 4),
                ],
              ),
              BlocBuilder<LoginBloc, LoginState>(
                builder: (context, state) {
                  return buildContent<LoginState>(
                    state: state,
                    isLoading: (state) => state.isLoading,
                    errorMessage: (state) => state.errorMessage,
                    hasData: (state) => state.user != null,
                    context: context,
                    contentBuilder: (state) {
                      return FutureBuilder<bool>(
                        future: NotificationService()
                            .checkSubscriptionStatus(widget.idShop),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return CircularProgressIndicator();
                          }
                          bool isSubscribed =
                              state.user!.notifications.contains(widget.idShop);
                          return ElevatedButton.icon(
                            onPressed: () async {
                              if (isSubscribed) {
                                await NotificationService()
                                    .unsubscribeFromTopic(widget.idShop);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(AppLocalizations.of(context)!.unsubscribed)),
                                );
                                state.user!.notifications.remove(widget.idShop);
                              } else {
                                await NotificationService()
                                    .subscribeToTopic(widget.idShop);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(AppLocalizations.of(context)!.subscribed)),
                                );
                                state.user!.notifications.add(widget.idShop);
                              }
                              context
                                  .read<LoginBloc>()
                                  .add(UpdateUserInfoEvent(user: state.user!));
                              setState(() {});
                            },
                            icon: Icon(isSubscribed
                                ? Icons.notifications_off
                                : Icons.notifications),
                            label: Text(
                                isSubscribed ? AppLocalizations.of(context)!.unsubscribed : AppLocalizations.of(context)!.subscribed),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
        const Divider(height: 1, thickness: 1),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: SingleChildScrollView(
              child: ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: widget.events?.length,
                itemBuilder: (context, index) {
                  final reserve = widget.events![index];
                  return GestureDetector(
                    onTap: () {
                      context.go(
                          '/user/events/${widget.idShop}/eventReserve/${reserve.id}');
                    },
                    child: CardReserve(
                        reserve: reserve,
                        idShop: widget.idShop,),
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
