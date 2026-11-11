import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:roll_and_reserve/core/failure.dart';
import 'package:roll_and_reserve/domain/entities/game_entity.dart';
import 'package:roll_and_reserve/domain/entities/genui_component_entity.dart';
import 'package:roll_and_reserve/domain/usecases/game_usecases/ask_game_rule_usecase.dart';
import 'package:roll_and_reserve/presentation/blocs/game_rules/game_rules_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/game_rules/game_rules_event.dart';
import 'package:roll_and_reserve/presentation/blocs/game_rules/game_rules_state.dart';

class MockAskGameRuleUseCase extends Mock implements AskGameRuleUseCase {}

void main() {
  late GameRulesBloc bloc;
  late MockAskGameRuleUseCase mockAskGameRuleUseCase;

  const tGame = GameEntity(
    id: 3,
    description: 'Juego de mesa de comercio',
    name: 'Catan',
    bggId: 13,
  );

  const tResponse = RulesAssistResponseEntity(
    game: {'name': 'Catan', 'id': 3},
    summary: 'El ladrón bloquea recursos.',
    components: [
      RuleCardComponentEntity(
        title: 'El Ladrón',
        steps: ['No produce recursos'],
      ),
    ],
    cached: false,
  );

  setUpAll(() {
    registerFallbackValue(
      const AskGameRuleParams(question: 'fallback'),
    );
  });

  setUp(() {
    mockAskGameRuleUseCase = MockAskGameRuleUseCase();
    bloc = GameRulesBloc(askGameRuleUseCase: mockAskGameRuleUseCase);
  });

  tearDown(() {
    bloc.close();
  });

  test('initial state should be GameRulesState()', () {
    expect(bloc.state, const GameRulesState());
  });

  blocTest<GameRulesBloc, GameRulesState>(
    'emits state with selectedGame and welcome message on SelectGameEvent',
    build: () => bloc,
    act: (bloc) => bloc.add(const SelectGameEvent(tGame)),
    verify: (bloc) {
      expect(bloc.state.selectedGame, tGame);
      expect(bloc.state.messages.length, 1);
      expect(bloc.state.messages.first.role, 'assistant');
      expect(bloc.state.messages.first.text, contains('Catan'));
    },
  );

  blocTest<GameRulesBloc, GameRulesState>(
    'emits [isLoading: true, updated messages] when AskRuleQuestionEvent succeeds',
    build: () {
      when(() => mockAskGameRuleUseCase(any()))
          .thenAnswer((_) async => const Right(tResponse));
      return bloc;
    },
    seed: () => const GameRulesState(selectedGame: tGame),
    act: (bloc) => bloc.add(const AskRuleQuestionEvent('¿Qué pasa al sacar un 7?')),
    expect: () => [
      isA<GameRulesState>()
          .having((s) => s.isLoading, 'isLoading', true)
          .having((s) => s.messages.length, 'messages.length', 1)
          .having((s) => s.messages.first.role, 'role', 'user'),
      isA<GameRulesState>()
          .having((s) => s.isLoading, 'isLoading', false)
          .having((s) => s.messages.length, 'messages.length', 2)
          .having((s) => s.messages.last.role, 'role', 'assistant')
          .having((s) => s.messages.last.text, 'text', 'El ladrón bloquea recursos.'),
    ],
  );

  blocTest<GameRulesBloc, GameRulesState>(
    'emits errorMessage when AskRuleQuestionEvent fails',
    build: () {
      when(() => mockAskGameRuleUseCase(any())).thenAnswer(
        (_) async => const Left(ServerFailure('Error en el servidor de IA')),
      );
      return bloc;
    },
    seed: () => const GameRulesState(selectedGame: tGame),
    act: (bloc) => bloc.add(const AskRuleQuestionEvent('Duda')),
    expect: () => [
      isA<GameRulesState>()
          .having((s) => s.isLoading, 'isLoading', true),
      isA<GameRulesState>()
          .having((s) => s.isLoading, 'isLoading', false)
          .having((s) => s.errorMessage, 'errorMessage', 'Error en el servidor de IA'),
    ],
  );

  blocTest<GameRulesBloc, GameRulesState>(
    'resets conversation to welcome message on ClearConversationEvent when game is selected',
    build: () => bloc,
    seed: () => const GameRulesState(selectedGame: tGame),
    act: (bloc) => bloc.add(const ClearConversationEvent()),
    verify: (bloc) {
      expect(bloc.state.messages.length, 1);
      expect(bloc.state.selectedGame, tGame);
    },
  );
}
