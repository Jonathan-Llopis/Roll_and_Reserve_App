import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:roll_and_reserve/core/failure.dart';
import 'package:roll_and_reserve/core/use_case.dart';
import 'package:roll_and_reserve/domain/entities/user_entity.dart';
import 'package:roll_and_reserve/domain/usecases/reserve_usecases/add_user_reserve_usecase.dart';
import 'package:roll_and_reserve/domain/usecases/reserve_usecases/delete_user_reserve_usecase.dart';
import 'package:roll_and_reserve/domain/usecases/user_usecases/get_last_ten_usecase.dart';
import 'package:roll_and_reserve/presentation/blocs/player/player_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/player/player_event.dart';
import 'package:roll_and_reserve/presentation/blocs/player/player_state.dart';

class MockGetLastTenPlayersUseCase extends Mock
    implements GetLastTenPlayersUseCase {}

class MockAddUserToReserveUseCase extends Mock
    implements AddUserToReserveUseCase {}

class MockDeleteUserOfReserveUseCase extends Mock
    implements DeleteUserOfReserveUseCase {}

class FakeIdGoogleParams extends Fake implements IdGoogleParams {}

class FakeUserToReserveUseCaseParams extends Fake
    implements UserToReserveUseCaseParams {}

void main() {
  late MockGetLastTenPlayersUseCase mockGetLastTenPlayersUseCase;
  late MockAddUserToReserveUseCase mockAddUserToReserveUseCase;
  late MockDeleteUserOfReserveUseCase mockDeleteUserOfReserveUseCase;

  setUpAll(() {
    registerFallbackValue(FakeIdGoogleParams());
    registerFallbackValue(FakeUserToReserveUseCaseParams());
  });

  setUp(() {
    mockGetLastTenPlayersUseCase = MockGetLastTenPlayersUseCase();
    mockAddUserToReserveUseCase = MockAddUserToReserveUseCase();
    mockDeleteUserOfReserveUseCase = MockDeleteUserOfReserveUseCase();
  });

  const testUsers = [
    UserEntity(
      id: 'google_1',
      name: 'Player One',
      username: 'player1',
      email: 'p1@example.com',
      avatar: 'avatar1.png',
      role: 0,
      averageRaiting: 4.5,
      notifications: [],
    ),
  ];

  group('PlayerBloc', () {
    test('initial state is PlayerInitial', () {
      final bloc = PlayerBloc(
        getLastTenPlayersUseCase: mockGetLastTenPlayersUseCase,
        addUserToReserveUseCase: mockAddUserToReserveUseCase,
        deleteUserToReserveUseCase: mockDeleteUserOfReserveUseCase,
      );
      expect(bloc.state, const PlayerInitial());
    });

    blocTest<PlayerBloc, PlayerState>(
      'emits [PlayerLoading, PlayerLoaded] when GetLastTenPlayersEvent succeeds',
      build: () {
        when(() => mockGetLastTenPlayersUseCase(any()))
            .thenAnswer((_) async => const Right(testUsers));
        return PlayerBloc(
          getLastTenPlayersUseCase: mockGetLastTenPlayersUseCase,
          addUserToReserveUseCase: mockAddUserToReserveUseCase,
          deleteUserToReserveUseCase: mockDeleteUserOfReserveUseCase,
        );
      },
      act: (bloc) =>
          bloc.add(const GetLastTenPlayersEvent(idGoogle: 'google_1')),
      expect: () => [
        const PlayerLoading(),
        const PlayerLoaded(lastUsers: testUsers),
      ],
    );

    blocTest<PlayerBloc, PlayerState>(
      'emits [PlayerLoading, PlayerFailure] when GetLastTenPlayersEvent fails',
      build: () {
        when(() => mockGetLastTenPlayersUseCase(any()))
            .thenAnswer((_) async => const Left(ServerFailure('User not found')));
        return PlayerBloc(
          getLastTenPlayersUseCase: mockGetLastTenPlayersUseCase,
          addUserToReserveUseCase: mockAddUserToReserveUseCase,
          deleteUserToReserveUseCase: mockDeleteUserOfReserveUseCase,
        );
      },
      act: (bloc) =>
          bloc.add(const GetLastTenPlayersEvent(idGoogle: 'google_1')),
      expect: () => [
        const PlayerLoading(),
        const PlayerFailure('User not found'),
      ],
    );

    blocTest<PlayerBloc, PlayerState>(
      'emits [PlayerLoading, PlayerLoaded] when AddPlayerToReserveEvent succeeds',
      build: () {
        when(() => mockAddUserToReserveUseCase(any()))
            .thenAnswer((_) async => const Right(true));
        return PlayerBloc(
          getLastTenPlayersUseCase: mockGetLastTenPlayersUseCase,
          addUserToReserveUseCase: mockAddUserToReserveUseCase,
          deleteUserToReserveUseCase: mockDeleteUserOfReserveUseCase,
        );
      },
      act: (bloc) => bloc.add(
        const AddPlayerToReserveEvent(
          idReserve: 1,
          idUser: 'google_1',
        ),
      ),
      expect: () => [
        const PlayerLoading(),
        const PlayerLoaded(operationSuccess: true),
      ],
    );

    blocTest<PlayerBloc, PlayerState>(
      'emits [PlayerLoading, PlayerLoaded] when RemovePlayerFromReserveEvent succeeds',
      build: () {
        when(() => mockDeleteUserOfReserveUseCase(any()))
            .thenAnswer((_) async => const Right(true));
        return PlayerBloc(
          getLastTenPlayersUseCase: mockGetLastTenPlayersUseCase,
          addUserToReserveUseCase: mockAddUserToReserveUseCase,
          deleteUserToReserveUseCase: mockDeleteUserOfReserveUseCase,
        );
      },
      act: (bloc) => bloc.add(
        const RemovePlayerFromReserveEvent(
          idReserve: 1,
          idUser: 'google_1',
        ),
      ),
      expect: () => [
        const PlayerLoading(),
        const PlayerLoaded(operationSuccess: true),
      ],
    );
  });
}
