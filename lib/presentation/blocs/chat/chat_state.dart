import 'package:equatable/equatable.dart';

class ChatState extends Equatable {
  final dynamic chat;
  final String newMessage;
  final bool isLoading;

  const ChatState({
    this.chat,
    this.newMessage = '',
    this.isLoading = false,
  });

  ChatState copyWith({
    dynamic chat,
    String? newMessage,
    bool? isLoading,
  }) {
    return ChatState(
      chat: chat ?? this.chat,
      newMessage: newMessage ?? this.newMessage,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [chat, newMessage, isLoading];

  factory ChatState.initial() => const ChatState();

  factory ChatState.loading(ChatState state) => state.copyWith(isLoading: true);

  factory ChatState.success(ChatState state, chat) => state.copyWith(isLoading: false, chat: chat);


}
