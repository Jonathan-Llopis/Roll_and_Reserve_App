import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:roll_and_reserve/core/failure.dart';
import 'package:roll_and_reserve/core/use_case.dart';
import 'package:roll_and_reserve/domain/entities/reserve_entity.dart';
import 'package:roll_and_reserve/domain/usecases/event_usecases/create_event_usecase.dart';
import 'package:roll_and_reserve/domain/usecases/event_usecases/get_events_shop_usecase.dart';
import 'package:roll_and_reserve/presentation/blocs/event/event_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/event/event_event.dart';
import 'package:roll_and_reserve/presentation/blocs/event/event_state.dart';

class MockGetEventsShopUsecase extends Mock implements GetEventsShopUsecase {}

class MockCreateEventsUsecase extends Mock implements CreateEventsUsecase {}

class FakeGetEventsParams extends Fake implements GetEventsParams {}

void main() {
  late MockGetEventsShopUsecase mockGetEventsShopUsecase;
  late MockCreateEventsUsecase mockCreateEventsUsecase;

  setUpAll(() {
    registerFallbackValue(FakeGetEventsParams());
  });

  setUp(() {
    mockGetEventsShopUsecase = MockGetEventsShopUsecase();
    mockCreateEventsUsecase = MockCreateEventsUsecase();
  });

  final testEvents = [
    ReserveEntity(
      id: 1,
      freePlaces: 4,
      dayDate: '2026-11-15',
      horaInicio: '18:00',
      horaFin: '20:00',
      description: 'Tournament',
      requiredMaterial: 'None',
      difficultyId: 1,
      gameId: 1,
      gameName: 'Catan',
      tableId: 2,
      usersInTables: 4,
      isEvent: true,
      userReserveId: 'user_123',
    ),
  ];

  group('EventBloc', () {
    test('initial state is EventInitial', () {
      final bloc = EventBloc(
        getEventsShopUsecase: mockGetEventsShopUsecase,
        createEventsUsecase: mockCreateEventsUsecase,
      );
      expect(bloc.state, const EventInitial());
    });

    blocTest<EventBloc, EventState>(
      'emits [EventLoading, EventLoaded] when GetShopEventsEvent succeeds',
      build: () {
        when(() => mockGetEventsShopUsecase(any()))
            .thenAnswer((_) async => Right(testEvents));
        return EventBloc(
          getEventsShopUsecase: mockGetEventsShopUsecase,
          createEventsUsecase: mockCreateEventsUsecase,
        );
      },
      act: (bloc) => bloc.add(const GetShopEventsEvent(idShop: 1)),
      expect: () => [
        const EventLoading(),
        EventLoaded(events: testEvents),
      ],
    );

    blocTest<EventBloc, EventState>(
      'emits [EventLoading, EventFailure] when GetShopEventsEvent fails',
      build: () {
        when(() => mockGetEventsShopUsecase(any()))
            .thenAnswer((_) async => const Left(ServerFailure('No events')));
        return EventBloc(
          getEventsShopUsecase: mockGetEventsShopUsecase,
          createEventsUsecase: mockCreateEventsUsecase,
        );
      },
      act: (bloc) => bloc.add(const GetShopEventsEvent(idShop: 1)),
      expect: () => [
        const EventLoading(),
        const EventFailure('No events'),
      ],
    );

    blocTest<EventBloc, EventState>(
      'emits [EventLoading, EventLoaded] when CreateShopEventEvent succeeds',
      build: () {
        when(() => mockCreateEventsUsecase(any()))
            .thenAnswer((_) async => const Right([1, 2]));
        return EventBloc(
          getEventsShopUsecase: mockGetEventsShopUsecase,
          createEventsUsecase: mockCreateEventsUsecase,
        );
      },
      act: (bloc) => bloc.add(CreateShopEventEvent(reserves: testEvents)),
      expect: () => [
        const EventLoading(),
        const EventLoaded(createdEventIds: [1, 2]),
      ],
    );
  });
}
