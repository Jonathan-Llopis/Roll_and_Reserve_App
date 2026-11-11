import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:roll_and_reserve/domain/entities/genui_component_entity.dart';
import 'package:roll_and_reserve/domain/usecases/game_usecases/ask_game_rule_usecase.dart';
import 'package:roll_and_reserve/presentation/blocs/game_rules/game_rules_event.dart';
import 'package:roll_and_reserve/presentation/blocs/game_rules/game_rules_state.dart';

class GameRulesBloc extends Bloc<GameRulesEvent, GameRulesState> {
  final AskGameRuleUseCase askGameRuleUseCase;

  GameRulesBloc({required this.askGameRuleUseCase})
      : super(const GameRulesState()) {
    on<SelectGameEvent>(_onSelectGame);
    on<AskRuleQuestionEvent>(_onAskRuleQuestion);
    on<ClearConversationEvent>(_onClearConversation);
  }

  void _onSelectGame(SelectGameEvent event, Emitter<GameRulesState> emit) {
    final game = event.game;
    final gameSuggestions = [
      '¿Cómo es la preparación de ${game.name}?',
      '¿Cuáles son las fases del turno en ${game.name}?',
      '¿Cómo se decide el ganador y el desempate?',
    ];

    final welcomeMessage = GameRulesChatMessage(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      role: 'assistant',
      text: '¡Hola! Soy tu árbitro de reglas para **${game.name}**. ¿Qué duda o situación de partida necesitas resolver?',
      genUiComponents: [
        QuickActionsComponentEntity(chips: gameSuggestions),
      ],
      timestamp: DateTime.now(),
    );

    emit(
      state.copyWith(
        selectedGame: game,
        initialSuggestions: gameSuggestions,
        messages: [welcomeMessage],
        clearError: true,
      ),
    );
  }

  Future<void> _onAskRuleQuestion(
    AskRuleQuestionEvent event,
    Emitter<GameRulesState> emit,
  ) async {
    final question = event.question.trim();
    if (question.isEmpty) return;

    final userMessage = GameRulesChatMessage(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      role: 'user',
      text: question,
      timestamp: DateTime.now(),
    );

    final updatedMessages = List<GameRulesChatMessage>.from(state.messages)
      ..add(userMessage);

    emit(
      state.copyWith(
        messages: updatedMessages,
        isLoading: true,
        clearError: true,
      ),
    );

    // Mapear historial conversacional previo para el contexto de la IA
    final history = state.messages
        .take(6)
        .map(
          (m) => {
            'role': m.role,
            'text': m.text,
          },
        )
        .toList();

    final result = await askGameRuleUseCase(
      AskGameRuleParams(
        question: question,
        gameId: state.selectedGame?.id,
        bggId: state.selectedGame?.bggId,
        gameName: state.selectedGame?.name,
        history: history,
      ),
    );

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            isLoading: false,
            errorMessage: failure.message,
          ),
        );
      },
      (response) {
        final assistantMessage = GameRulesChatMessage(
          id: (DateTime.now().microsecondsSinceEpoch + 1).toString(),
          role: 'assistant',
          text: response.summary,
          genUiComponents: response.components,
          isCached: response.cached,
          timestamp: DateTime.now(),
        );

        emit(
          state.copyWith(
            isLoading: false,
            messages: List<GameRulesChatMessage>.from(state.messages)
              ..add(assistantMessage),
          ),
        );
      },
    );
  }

  void _onClearConversation(
    ClearConversationEvent event,
    Emitter<GameRulesState> emit,
  ) {
    if (state.selectedGame != null) {
      add(SelectGameEvent(state.selectedGame!));
    } else {
      emit(state.copyWith(messages: []));
    }
  }
}
