import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:roll_and_reserve/core/use_case.dart';
import 'package:roll_and_reserve/domain/usecases/event_usecases/create_event_usecase.dart';
import 'package:roll_and_reserve/domain/usecases/event_usecases/get_events_shop_usecase.dart';
import 'package:roll_and_reserve/presentation/blocs/event/event_event.dart';
import 'package:roll_and_reserve/presentation/blocs/event/event_state.dart';

class EventBloc extends Bloc<EventEvent, EventState> {
  final GetEventsShopUsecase getEventsShopUsecase;
  final CreateEventsUsecase createEventsUsecase;

  EventBloc({
    required this.getEventsShopUsecase,
    required this.createEventsUsecase,
  }) : super(const EventInitial()) {
    on<GetShopEventsEvent>(_onGetShopEvents);
    on<CreateShopEventEvent>(_onCreateShopEvent);
  }

  Future<void> _onGetShopEvents(
    GetShopEventsEvent event,
    Emitter<EventState> emit,
  ) async {
    emit(
      EventLoading(
        events: state.events,
        createdEventIds: state.createdEventIds,
      ),
    );
    final result =
        await getEventsShopUsecase(GetEventsParams(idShop: event.idShop));
    result.fold(
      (failure) => emit(
        EventFailure(
          failure.message,
          events: state.events,
          createdEventIds: state.createdEventIds,
        ),
      ),
      (events) => emit(
        EventLoaded(
          events: events,
          createdEventIds: state.createdEventIds,
        ),
      ),
    );
  }

  Future<void> _onCreateShopEvent(
    CreateShopEventEvent event,
    Emitter<EventState> emit,
  ) async {
    emit(
      EventLoading(
        events: state.events,
        createdEventIds: state.createdEventIds,
      ),
    );
    final result = await createEventsUsecase(event.reserves);
    result.fold(
      (failure) => emit(
        EventFailure(
          failure.message,
          events: state.events,
          createdEventIds: state.createdEventIds,
        ),
      ),
      (ids) => emit(
        EventLoaded(
          events: state.events,
          createdEventIds: ids,
        ),
      ),
    );
  }
}
