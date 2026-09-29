import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

sealed class ChatEvent extends Equatable {
  const ChatEvent();
}

final class OnChatStart extends ChatEvent {
  const OnChatStart({
    required this.message,
    this.context,
    this.languageCode,
  });

  final BuildContext? context;
  final String message;
  final String? languageCode;

  String get effectiveLanguageCode {
    if (languageCode != null) return languageCode!;
    if (context != null) {
      try {
        return Localizations.localeOf(context!).languageCode;
      } catch (_) {}
    }
    return 'es';
  }

  @override
  List<Object?> get props => [
        message,
        languageCode,
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
  final BuildContext? context;
  final String? languageCode;

  const OnRolPlayStart({
    required this.character,
    required this.theme,
    this.context,
    this.languageCode,
  });

  String get effectiveLanguageCode {
    if (languageCode != null) return languageCode!;
    if (context != null) {
      try {
        return Localizations.localeOf(context!).languageCode;
      } catch (_) {}
    }
    return 'es';
  }

  @override
  List<Object?> get props => [character, theme, languageCode];
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
    this.context,
    this.languageCode,
  });

  final BuildContext? context;
  final String? languageCode;

  String get effectiveLanguageCode {
    if (languageCode != null) return languageCode!;
    if (context != null) {
      try {
        return Localizations.localeOf(context!).languageCode;
      } catch (_) {}
    }
    return 'es';
  }

  @override
  List<Object?> get props => [languageCode];
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

final class CleanChatGemini extends ChatEvent {
  const CleanChatGemini();

  @override
  List<Object?> get props => [];
}

final class OnChatAssistantStart extends ChatEvent {
  const OnChatAssistantStart({
    this.context,
    this.languageCode,
  });

  final BuildContext? context;
  final String? languageCode;

  String get effectiveLanguageCode {
    if (languageCode != null) return languageCode!;
    if (context != null) {
      try {
        return Localizations.localeOf(context!).languageCode;
      } catch (_) {}
    }
    return 'es';
  }

  @override
  List<Object?> get props => [languageCode];
}

final class OnChatAssistantSendMessage extends ChatEvent {
  const OnChatAssistantSendMessage({
    required this.message,
    this.imageBytes,
  });
  final String message;
  final List<ByteData>? imageBytes;

  @override
  List<Object?> get props => [message, imageBytes];
}

final class CleanChatAssistant extends ChatEvent {
  const CleanChatAssistant();

  @override
  List<Object?> get props => [];
}
