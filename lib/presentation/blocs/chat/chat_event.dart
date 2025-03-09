import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

sealed class ChatEvent extends Equatable {
  const ChatEvent();
}

final class OnChatStart extends ChatEvent {
  const OnChatStart({
    required this.context,
  });

  final BuildContext context;

  @override
  List<Object?> get props => [context];
}

final class OnChatSendMessage extends ChatEvent {
  const OnChatSendMessage({
    required this.message,
  });
  final String message;

  @override
  List<Object?> get props => [message];
}
