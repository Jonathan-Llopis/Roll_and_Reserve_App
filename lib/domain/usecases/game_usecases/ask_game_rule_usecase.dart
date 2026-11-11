import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:roll_and_reserve/core/failure.dart';
import 'package:roll_and_reserve/core/use_case.dart';
import 'package:roll_and_reserve/domain/entities/genui_component_entity.dart';
import 'package:roll_and_reserve/domain/repositories/game_repository.dart';

class AskGameRuleParams extends Equatable {
  final String question;
  final int? gameId;
  final int? bggId;
  final String? gameName;
  final List<Map<String, String>>? history;

  const AskGameRuleParams({
    required this.question,
    this.gameId,
    this.bggId,
    this.gameName,
    this.history,
  });

  @override
  List<Object?> get props => [question, gameId, bggId, gameName, history];
}

class AskGameRuleUseCase
    implements UseCase<Either<Failure, RulesAssistResponseEntity>, AskGameRuleParams> {
  final GameRepository repository;

  AskGameRuleUseCase(this.repository);

  @override
  Future<Either<Failure, RulesAssistResponseEntity>> call(
    AskGameRuleParams params,
  ) async {
    return await repository.askGameRule(
      question: params.question,
      gameId: params.gameId,
      bggId: params.bggId,
      gameName: params.gameName,
      history: params.history,
    );
  }
}
