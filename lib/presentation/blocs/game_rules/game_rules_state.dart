import 'package:equatable/equatable.dart';
import 'package:roll_and_reserve/domain/entities/game_entity.dart';
import 'package:roll_and_reserve/domain/entities/genui_component_entity.dart';

class GameRulesChatMessage extends Equatable {
  final String id;
  final String role; // 'user' | 'assistant'
  final String text;
  final List<GenUiComponentEntity>? genUiComponents;
  final bool isCached;
  final DateTime timestamp;

  const GameRulesChatMessage({
    required this.id,
    required this.role,
    required this.text,
    this.genUiComponents,
    this.isCached = false,
    required this.timestamp,
  });

  @override
  List<Object?> get props => [
        id,
        role,
        text,
        genUiComponents,
        isCached,
        timestamp,
      ];
}

class GameRulesState extends Equatable {
  final GameEntity? selectedGame;
  final List<GameRulesChatMessage> messages;
  final bool isLoading;
  final String? errorMessage;
  final List<String> initialSuggestions;

  const GameRulesState({
    this.selectedGame,
    this.messages = const [],
    this.isLoading = false,
    this.errorMessage,
    this.initialSuggestions = const [
      '¿Cómo es la preparación inicial del juego?',
      '¿Cuáles son las fases de cada turno?',
      '¿Cómo se determina el ganador y el desempate?',
    ],
  });

  GameRulesState copyWith({
    GameEntity? selectedGame,
    bool clearSelectedGame = false,
    List<GameRulesChatMessage>? messages,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
    List<String>? initialSuggestions,
  }) {
    return GameRulesState(
      selectedGame: clearSelectedGame
          ? null
          : (selectedGame ?? this.selectedGame),
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      initialSuggestions: initialSuggestions ?? this.initialSuggestions,
    );
  }

  @override
  List<Object?> get props => [
        selectedGame,
        messages,
        isLoading,
        errorMessage,
        initialSuggestions,
      ];
}
