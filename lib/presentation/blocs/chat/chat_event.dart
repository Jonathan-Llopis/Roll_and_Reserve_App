import 'package:equatable/equatable.dart';

sealed class ChatEvent extends Equatable {
  const ChatEvent();
}
final class OnChatStart extends ChatEvent {
  const OnChatStart();

  @override
  List<Object?> get props => [];
}

final class OnChatSendMessage extends ChatEvent {
  const OnChatSendMessage({
    required this.message,
  });
  final String message;

  @override
  List<Object?> get props => [message];
}