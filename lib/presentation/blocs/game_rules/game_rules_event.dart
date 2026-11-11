import 'package:equatable/equatable.dart';
import 'package:roll_and_reserve/domain/entities/game_entity.dart';

abstract class GameRulesEvent extends Equatable {
  const GameRulesEvent();

  @override
  List<Object?> get props => [];
}

class SelectGameEvent extends GameRulesEvent {
  final GameEntity game;

  const SelectGameEvent(this.game);

  @override
  List<Object?> get props => [game];
}

class AskRuleQuestionEvent extends GameRulesEvent {
  final String question;

  const AskRuleQuestionEvent(this.question);

  @override
  List<Object?> get props => [question];
}

class ClearConversationEvent extends GameRulesEvent {
  const ClearConversationEvent();
}
