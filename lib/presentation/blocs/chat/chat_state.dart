import 'package:equatable/equatable.dart';

class ChatState extends Equatable {
  final String newMessage;
  final bool isLoading;
  final List<Map<String, String>> messages;

  const ChatState({
    this.newMessage = '',
    this.isLoading = false,
    this.messages = const [],
  });

  ChatState copyWith({
    dynamic chat,
    String? newMessage,
    bool? isLoading,
    List<Map<String, String>>? messages,
  }) {
    return ChatState(
      newMessage: newMessage ?? this.newMessage,
      isLoading: isLoading ?? this.isLoading,
      messages: messages ?? this.messages,
    );
  }

  @override
  List<Object?> get props => [newMessage, isLoading];

  factory ChatState.initial() => const ChatState();

  factory ChatState.loading(ChatState state) => state.copyWith(isLoading: true);

  factory ChatState.success(ChatState state, messages) => state.copyWith(isLoading: false, messages: messages);

  factory ChatState.userMessage(ChatState state, messages) => state.copyWith(messages: messages, isLoading: false);

  factory ChatState.clean(ChatState state) => state.copyWith(messages: [], isLoading: false);

}
