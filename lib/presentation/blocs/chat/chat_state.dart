import 'package:equatable/equatable.dart';

sealed class ChatState extends Equatable {
  final String newMessage;
  final List<Map<String, String>> messages;
  final List<Map<String, String>> messagesRol;
  final Map<String, dynamic> character;
  final List<Map<String, String>> messagesGemini;
  final List<Map<String, String>> messagesAssistant;

  const ChatState({
    this.newMessage = '',
    this.messages = const [],
    this.messagesRol = const [],
    this.character = const {},
    this.messagesGemini = const [],
    this.messagesAssistant = const [],
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
  });

  @override
  List<Object?> get props => [super.props, message];
}
