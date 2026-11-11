import 'package:equatable/equatable.dart';
import 'package:roll_and_reserve/domain/entities/chat_message_entity.dart';

sealed class ChatState extends Equatable {
  final String newMessage;
  final List<Map<String, String>> messages;
  final List<Map<String, String>> messagesRol;
  final Map<String, dynamic> character;
  final List<Map<String, String>> messagesGemini;
  final List<Map<String, String>> messagesAssistant;
  final List<ChatMessageEntity> history;

  const ChatState({
    this.newMessage = '',
    this.messages = const [],
    this.messagesRol = const [],
    this.character = const {},
    this.messagesGemini = const [],
    this.messagesAssistant = const [],
    this.history = const [],
  });

  bool get isLoading => this is ChatLoading;

  @override
  List<Object?> get props => [
        newMessage,
        messages,
        messagesRol,
        character,
        messagesGemini,
        messagesAssistant,
        history,
      ];
}

class ChatInitial extends ChatState {
  const ChatInitial() : super();
}

class ChatLoading extends ChatState {
  const ChatLoading({
    super.newMessage,
    super.messages,
    super.messagesRol,
    super.character,
    super.messagesGemini,
    super.messagesAssistant,
    super.history,
  });
}

class ChatSuccess extends ChatState {
  const ChatSuccess({
    super.newMessage,
    super.messages,
    super.messagesRol,
    super.character,
    super.messagesGemini,
    super.messagesAssistant,
    super.history,
  });
}

class ChatFailure extends ChatState {
  final String message;
  const ChatFailure(
    this.message, {
    super.newMessage,
    super.messages,
    super.messagesRol,
    super.character,
    super.messagesGemini,
    super.messagesAssistant,
    super.history,
  });

  @override
  List<Object?> get props => [...super.props, message];
}
