import 'package:equatable/equatable.dart';

abstract class GenUiComponentEntity extends Equatable {
  final String type;

  const GenUiComponentEntity({required this.type});

  @override
  List<Object?> get props => [type];
}

class RuleCardComponentEntity extends GenUiComponentEntity {
  final String title;
  final String badge;
  final String severity; // 'critical', 'warning', 'info'
  final List<String> steps;

  const RuleCardComponentEntity({
    required this.title,
    this.badge = 'Regla',
    this.severity = 'info',
    required this.steps,
  }) : super(type: 'rule_card');

  @override
  List<Object?> get props => [type, title, badge, severity, steps];
}

class TurnPhaseEntity extends Equatable {
  final int phaseNumber;
  final String phaseName;
  final String description;

  const TurnPhaseEntity({
    required this.phaseNumber,
    required this.phaseName,
    required this.description,
  });

  @override
  List<Object?> get props => [phaseNumber, phaseName, description];
}

class TurnCarouselComponentEntity extends GenUiComponentEntity {
  final List<TurnPhaseEntity> phases;

  const TurnCarouselComponentEntity({
    required this.phases,
  }) : super(type: 'turn_carousel');

  @override
  List<Object?> get props => [type, phases];
}

class QuickActionsComponentEntity extends GenUiComponentEntity {
  final List<String> chips;

  const QuickActionsComponentEntity({
    required this.chips,
  }) : super(type: 'quick_actions');

  @override
  List<Object?> get props => [type, chips];
}

class TextCardComponentEntity extends GenUiComponentEntity {
  final String content;

  const TextCardComponentEntity({
    required this.content,
  }) : super(type: 'text_card');

  @override
  List<Object?> get props => [type, content];
}

class RulesAssistResponseEntity extends Equatable {
  final Map<String, dynamic> game;
  final String summary;
  final List<GenUiComponentEntity> components;
  final bool cached;

  const RulesAssistResponseEntity({
    required this.game,
    required this.summary,
    required this.components,
    this.cached = false,
  });

  @override
  List<Object?> get props => [game, summary, components, cached];
}
