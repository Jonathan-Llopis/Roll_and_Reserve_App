import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:roll_and_reserve/domain/entities/genui_component_entity.dart';
import 'package:roll_and_reserve/domain/repositories/game_repository.dart';
import 'package:roll_and_reserve/domain/usecases/game_usecases/ask_game_rule_usecase.dart';

class MockGameRepository extends Mock implements GameRepository {}

void main() {
  late AskGameRuleUseCase useCase;
  late MockGameRepository mockRepository;

  setUp(() {
    mockRepository = MockGameRepository();
    useCase = AskGameRuleUseCase(mockRepository);
  });

  const tResponse = RulesAssistResponseEntity(
    game: {'name': 'Catan', 'id': 3},
    summary: 'Resumen',
    components: [
      RuleCardComponentEntity(
        title: 'Regla',
        steps: ['Paso 1'],
      ),
    ],
  );

  test('should call repository.askGameRule with expected parameters', () async {
    when(
      () => mockRepository.askGameRule(
        question: any(named: 'question'),
        gameId: any(named: 'gameId'),
        bggId: any(named: 'bggId'),
        gameName: any(named: 'gameName'),
        history: any(named: 'history'),
      ),
    ).thenAnswer((_) async => const Right(tResponse));

    const params = AskGameRuleParams(
      question: '¿Qué pasa al sacar un 7?',
      gameId: 3,
      bggId: 13,
      gameName: 'Catan',
    );

    final result = await useCase(params);

    expect(result, const Right(tResponse));
    verify(
      () => mockRepository.askGameRule(
        question: '¿Qué pasa al sacar un 7?',
        gameId: 3,
        bggId: 13,
        gameName: 'Catan',
        history: null,
      ),
    ).called(1);
  });
}
