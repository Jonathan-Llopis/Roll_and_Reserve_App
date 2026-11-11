import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:roll_and_reserve/core/failure.dart';
import 'package:roll_and_reserve/core/use_case.dart';
import 'package:roll_and_reserve/domain/entities/category_game_entity.dart';
import 'package:roll_and_reserve/domain/entities/difficulty_entity.dart';
import 'package:roll_and_reserve/domain/entities/game_entity.dart';
import 'package:roll_and_reserve/domain/usecases/game_usecases/get_all_categories_usecase.dart';
import 'package:roll_and_reserve/domain/usecases/game_usecases/get_all_difficulties_usecase.dart';
import 'package:roll_and_reserve/domain/usecases/game_usecases/get_all_games_usecase.dart';
import 'package:roll_and_reserve/domain/usecases/game_usecases/search_games_usecase.dart';
import 'package:roll_and_reserve/presentation/blocs/game/game_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/game/game_event.dart';
import 'package:roll_and_reserve/presentation/blocs/game/game_state.dart';

class MockGetAllGameUseCase extends Mock implements GetAllGameUseCase {}

class MockGetAllCategoryGamesUseCase extends Mock
    implements GetAllCategoryGamesUseCase {}

class MockGetAllDifficultyUseCase extends Mock
    implements GetAllDifficultyUseCase {}

class MockSearchGamesUseCase extends Mock implements SearchGamesUseCase {}

class FakeNoParams extends Fake implements NoParams {}

void main() {
  late MockGetAllGameUseCase mockGetAllGameUseCase;
  late MockGetAllCategoryGamesUseCase mockGetAllCategoryGamesUseCase;
  late MockGetAllDifficultyUseCase mockGetAllDifficultyUseCase;
  late MockSearchGamesUseCase mockSearchGamesUseCase;

  setUpAll(() {
    registerFallbackValue(FakeNoParams());
  });

  setUp(() {
    mockGetAllGameUseCase = MockGetAllGameUseCase();
    mockGetAllCategoryGamesUseCase = MockGetAllCategoryGamesUseCase();
    mockGetAllDifficultyUseCase = MockGetAllDifficultyUseCase();
    mockSearchGamesUseCase = MockSearchGamesUseCase();
  });

  const testGames = [
    GameEntity(
      id: 1,
      description: 'Catan',
    ),
  ];

  const testCategories = [
    GameCategoryEntity(
      id: 1,
      description: 'Strategy',
    ),
  ];

  const testDifficulties = [
    DifficultyEntity(
      id: 1,
      description: 'Medium',
    ),
  ];

  group('GameBloc', () {
    test('initial state is GameInitial', () {
      final bloc = GameBloc(
        getAllGameUseCase: mockGetAllGameUseCase,
        getAllCategoryGamesUseCase: mockGetAllCategoryGamesUseCase,
        getAllDifficultyUseCase: mockGetAllDifficultyUseCase,
        searchGamesUseCase: mockSearchGamesUseCase,
      );
      expect(bloc.state, const GameInitial());
    });

    blocTest<GameBloc, GameState>(
      'emits [GameLoading, GameLoaded] when GetAllGamesEvent succeeds',
      build: () {
        when(() => mockGetAllGameUseCase(any()))
            .thenAnswer((_) async => const Right(testGames));
        return GameBloc(
          getAllGameUseCase: mockGetAllGameUseCase,
          getAllCategoryGamesUseCase: mockGetAllCategoryGamesUseCase,
          getAllDifficultyUseCase: mockGetAllDifficultyUseCase,
          searchGamesUseCase: mockSearchGamesUseCase,
        );
      },
      act: (bloc) => bloc.add(const GetAllGamesEvent()),
      expect: () => [
        const GameLoading(),
        const GameLoaded(games: testGames),
      ],
    );

    blocTest<GameBloc, GameState>(
      'emits [GameLoading, GameFailure] when GetAllGamesEvent fails',
      build: () {
        when(() => mockGetAllGameUseCase(any()))
            .thenAnswer((_) async => const Left(ServerFailure('Server Error')));
        return GameBloc(
          getAllGameUseCase: mockGetAllGameUseCase,
          getAllCategoryGamesUseCase: mockGetAllCategoryGamesUseCase,
          getAllDifficultyUseCase: mockGetAllDifficultyUseCase,
          searchGamesUseCase: mockSearchGamesUseCase,
        );
      },
      act: (bloc) => bloc.add(const GetAllGamesEvent()),
      expect: () => [
        const GameLoading(),
        const GameFailure('Server Error'),
      ],
    );

    blocTest<GameBloc, GameState>(
      'emits [GameLoading, GameLoaded] when GetAllCategoriesEvent succeeds',
      build: () {
        when(() => mockGetAllCategoryGamesUseCase(any()))
            .thenAnswer((_) async => const Right(testCategories));
        return GameBloc(
          getAllGameUseCase: mockGetAllGameUseCase,
          getAllCategoryGamesUseCase: mockGetAllCategoryGamesUseCase,
          getAllDifficultyUseCase: mockGetAllDifficultyUseCase,
          searchGamesUseCase: mockSearchGamesUseCase,
        );
      },
      act: (bloc) => bloc.add(const GetAllCategoriesEvent()),
      expect: () => [
        const GameLoading(),
        const GameLoaded(categories: testCategories),
      ],
    );

    blocTest<GameBloc, GameState>(
      'emits [GameLoading, GameLoaded] when GetAllDifficultiesEvent succeeds',
      build: () {
        when(() => mockGetAllDifficultyUseCase(any()))
            .thenAnswer((_) async => const Right(testDifficulties));
        return GameBloc(
          getAllGameUseCase: mockGetAllGameUseCase,
          getAllCategoryGamesUseCase: mockGetAllCategoryGamesUseCase,
          getAllDifficultyUseCase: mockGetAllDifficultyUseCase,
          searchGamesUseCase: mockSearchGamesUseCase,
        );
      },
      act: (bloc) => bloc.add(const GetAllDifficultiesEvent()),
      expect: () => [
        const GameLoading(),
        const GameLoaded(difficulties: testDifficulties),
      ],
    );

    blocTest<GameBloc, GameState>(
      'emits [GameLoading, GameLoaded] when SearchGameByNameEvent succeeds',
      build: () {
        when(() => mockSearchGamesUseCase('Catan'))
            .thenAnswer((_) async => const Right(testGames));
        return GameBloc(
          getAllGameUseCase: mockGetAllGameUseCase,
          getAllCategoryGamesUseCase: mockGetAllCategoryGamesUseCase,
          getAllDifficultyUseCase: mockGetAllDifficultyUseCase,
          searchGamesUseCase: mockSearchGamesUseCase,
        );
      },
      act: (bloc) => bloc.add(const SearchGameByNameEvent(gameName: 'Catan')),
      expect: () => [
        const GameLoading(),
        const GameLoaded(searchedGames: testGames),
      ],
    );
  });
}
