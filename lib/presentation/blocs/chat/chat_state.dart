import 'package:equatable/equatable.dart';

class ChatState extends Equatable {
  final String newMessage;
  final bool isLoading;
  final List<Map<String, String>> messages;
  final List<Map<String, String>> messagesRol;
  final Map<String, dynamic> character;
  final List<Map<String, String>> messagesGemini;

  const ChatState({
    this.newMessage = '',
    this.isLoading = false,
    this.messages = const [],
    this.messagesRol = const [],
    this.character = const {},
    this.messagesGemini = const [],
  });

  ChatState copyWith({
    dynamic chat,
    String? newMessage,
    bool? isLoading,
    List<Map<String, String>>? messages,
    List<Map<String, String>>? messagesRol,
    Map<String, dynamic>? character,
    List<Map<String, String>>? messagesGemini,
  }) {
    return ChatState(
      newMessage: newMessage ?? this.newMessage,
      isLoading: isLoading ?? this.isLoading,
      messages: messages ?? this.messages,
      messagesRol: messagesRol ?? this.messagesRol,
      character: character ?? this.character,
      messagesGemini: messagesGemini ?? this.messagesGemini,
    );
  }

  @override
  List<Object?> get props => [
        newMessage,
        isLoading,
        messages,
        messagesRol,
        character,
        messagesGemini,
      ];

  factory ChatState.initial() => const ChatState();

  factory ChatState.loading(ChatState state) => state.copyWith(isLoading: true);

  factory ChatState.success(ChatState state, messages) =>
      state.copyWith(isLoading: false, messages: messages);

  factory ChatState.userMessage(ChatState state, messages) =>
      state.copyWith(messages: messages, isLoading: false);

  factory ChatState.rolUserMessage(
    ChatState state,
    messages,
  ) =>
      state.copyWith(
        messagesRol: messages,
        isLoading: false,
      );

  factory ChatState.rolMessage(ChatState state, messages, character) => state
      .copyWith(messagesRol: messages, isLoading: false, character: character);

  factory ChatState.clean(ChatState state) => state.copyWith(
        messages: [],
        isLoading: false,
      );
  factory ChatState.cleanRol(ChatState state) => state.copyWith(
        messagesRol: const [],
        character: const {},
        isLoading: false,
      );

  factory ChatState.geminiMessage(ChatState state, messages) =>
      state.copyWith(messagesGemini: messages, isLoading: false);
  factory ChatState.geminiUserMessage(ChatState state, messages) =>
      state.copyWith(messagesGemini: messages, isLoading: false);
  factory ChatState.geminiLoading(ChatState state) =>
      state.copyWith(isLoading: true, messagesGemini: state.messagesGemini);
  factory ChatState.geminiClean(ChatState state) => state.copyWith(
        messagesGemini: [],
        isLoading: false,
      );
}
