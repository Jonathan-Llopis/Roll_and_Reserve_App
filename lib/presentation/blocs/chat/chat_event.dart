import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

sealed class ChatEvent extends Equatable {
  const ChatEvent();
}

final class OnChatStart extends ChatEvent {
  const OnChatStart({
    required this.context,
    required this.message,
  });

  final BuildContext context;
  final String message;

  @override
  List<Object?> get props => [
        context,
      ];
}

final class OnChatSendMessage extends ChatEvent {
  const OnChatSendMessage({
    required this.message,
  });
  final String message;

  @override
  List<Object?> get props => [message];
}

final class CleanChat extends ChatEvent {
  @override
  List<Object?> get props => [];
}

final class OnRolPlayStart extends ChatEvent {
  final String theme;
  final String character;
  const OnRolPlayStart({
    required this.context,
    required this.character,
    required this.theme,
  });

  final BuildContext context;

  @override
  List<Object?> get props => [context, character, theme];
}

final class OnRolPlaySendMessage extends ChatEvent {
  const OnRolPlaySendMessage({
    required this.message,
  });
  final String message;

  @override
  List<Object?> get props => [message];
}

final class CleanRolPlay extends ChatEvent {
  const CleanRolPlay();

  @override
  List<Object?> get props => [];
}

final class OnChatGeminiStart extends ChatEvent {
  const OnChatGeminiStart({
    required this.context,
  });

  final BuildContext context;

  @override
  List<Object?> get props => [context];
}

final class OnChatGeminiSendMessage extends ChatEvent {
  const OnChatGeminiSendMessage({
    required this.message,
    this.imageBytes,
  });
  final String message;
  final List<ByteData>? imageBytes;

  @override
  List<Object?> get props => [message, imageBytes];
}
