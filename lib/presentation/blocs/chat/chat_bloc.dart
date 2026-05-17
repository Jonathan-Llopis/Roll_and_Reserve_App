import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:roll_and_reserve/core/use_case.dart';
import 'package:roll_and_reserve/domain/usecases/chat_usecases/send_message_assistant_usecase.dart';
import 'package:roll_and_reserve/domain/usecases/chat_usecases/send_message_gemini_usecase.dart';
import 'package:roll_and_reserve/domain/usecases/chat_usecases/send_message_usecase.dart';
import 'package:roll_and_reserve/domain/usecases/chat_usecases/send_rol_message_usecase.dart';
import 'package:roll_and_reserve/domain/usecases/chat_usecases/start_chat_assistant_usecases.dart';
import 'package:roll_and_reserve/domain/usecases/chat_usecases/start_chat_gemini_usecases.dart';
import 'package:roll_and_reserve/domain/usecases/chat_usecases/start_chat_rol_usecases.dart';
import 'package:roll_and_reserve/domain/usecases/chat_usecases/start_chat_usecases.dart';
import 'package:roll_and_reserve/presentation/blocs/chat/chat_event.dart';
import 'package:roll_and_reserve/presentation/blocs/chat/chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final StartChatUseCase startChatUseCase;
  final SendMessageUseCase sendMessageUseCase;
  final StartChatRolUseCase startChatRolUseCase;
  final SendRolMessageUseCase sendRolMessageUseCase;
  final StartChatGeminiUsecases startChatGeminiUseCase;
  final SendMessageGeminiUsecase sendMessageGeminiUseCase;
  final StartChatAssistantUsecases startChatAssistantUsecases;
  final SendMessageAssistantUsecase sendMessageAssistantUsecase;

  ChatBloc(
    this.startChatUseCase,
    this.sendMessageUseCase,
    this.startChatRolUseCase,
    this.sendRolMessageUseCase,
    this.startChatGeminiUseCase,
    this.sendMessageGeminiUseCase,
    this.startChatAssistantUsecases,
    this.sendMessageAssistantUsecase,
  ) : super(const ChatInitial()) {
    on<OnChatStart>((event, emit) async {
      emit(
        ChatLoading(
          newMessage: state.newMessage,
          messages: state.messages,
          messagesRol: state.messagesRol,
          character: state.character,
          messagesGemini: state.messagesGemini,
          messagesAssistant: state.messagesAssistant,
        ),
      );
      try {
        final List<Map<String, String>> messagesUpdate = [
          {'role': 'user', 'text': event.message},
        ];
        emit(
          ChatSuccess(
            newMessage: state.newMessage,
            messages: messagesUpdate,
            messagesRol: state.messagesRol,
            character: state.character,
            messagesGemini: state.messagesGemini,
            messagesAssistant: state.messagesAssistant,
          ),
        );
        emit(
          ChatLoading(
            newMessage: state.newMessage,
            messages: state.messages,
            messagesRol: state.messagesRol,
            character: state.character,
            messagesGemini: state.messagesGemini,
            messagesAssistant: state.messagesAssistant,
          ),
        );
        final responseIA = await startChatUseCase(
          StartChatParams(event.context, message: event.message),
        );
        final List<Map<String, String>> finalMessages =
            List.from(state.messages)..add({'role': 'IA', 'text': responseIA});
        emit(
          ChatSuccess(
            newMessage: state.newMessage,
            messages: finalMessages,
            messagesRol: state.messagesRol,
            character: state.character,
            messagesGemini: state.messagesGemini,
            messagesAssistant: state.messagesAssistant,
          ),
        );
      } catch (e) {
        emit(
          ChatFailure(
            'Error al iniciar chat: $e',
            newMessage: state.newMessage,
            messages: state.messages,
            messagesRol: state.messagesRol,
            character: state.character,
            messagesGemini: state.messagesGemini,
            messagesAssistant: state.messagesAssistant,
          ),
        );
      }
    });

    on<OnChatSendMessage>((event, emit) async {
      emit(
        ChatLoading(
          newMessage: state.newMessage,
          messages: state.messages,
          messagesRol: state.messagesRol,
          character: state.character,
          messagesGemini: state.messagesGemini,
          messagesAssistant: state.messagesAssistant,
        ),
      );
      final List<Map<String, String>> messagesUpdate = List.from(state.messages)
        ..add({'role': 'user', 'text': event.message});
      emit(
        ChatSuccess(
          newMessage: state.newMessage,
          messages: messagesUpdate,
          messagesRol: state.messagesRol,
          character: state.character,
          messagesGemini: state.messagesGemini,
          messagesAssistant: state.messagesAssistant,
        ),
      );
      emit(
        ChatLoading(
          newMessage: state.newMessage,
          messages: state.messages,
          messagesRol: state.messagesRol,
          character: state.character,
          messagesGemini: state.messagesGemini,
          messagesAssistant: state.messagesAssistant,
        ),
      );
      try {
        final responseIA =
            await sendMessageUseCase(SendMessageParams(event.message));
        final List<Map<String, String>> messagesUpdateIA =
            List.from(state.messages)..add({'role': 'IA', 'text': responseIA});
        emit(
          ChatSuccess(
            newMessage: state.newMessage,
            messages: messagesUpdateIA,
            messagesRol: state.messagesRol,
            character: state.character,
            messagesGemini: state.messagesGemini,
            messagesAssistant: state.messagesAssistant,
          ),
        );
      } catch (e) {
        emit(
          ChatFailure(
            'Error al enviar mensaje: $e',
            newMessage: state.newMessage,
            messages: state.messages,
            messagesRol: state.messagesRol,
            character: state.character,
            messagesGemini: state.messagesGemini,
            messagesAssistant: state.messagesAssistant,
          ),
        );
      }
    });

    on<CleanChat>((event, emit) {
      emit(
        ChatSuccess(
          newMessage: state.newMessage,
          messages: const [],
          messagesRol: state.messagesRol,
          character: state.character,
          messagesGemini: state.messagesGemini,
          messagesAssistant: state.messagesAssistant,
        ),
      );
    });

    on<OnRolPlayStart>((event, emit) async {
      emit(
        ChatLoading(
          newMessage: state.newMessage,
          messages: state.messages,
          messagesRol: state.messagesRol,
          character: state.character,
          messagesGemini: state.messagesGemini,
          messagesAssistant: state.messagesAssistant,
        ),
      );
      try {
        final responseIA = await startChatRolUseCase(
          StartRolPlayParams(
            event.context,
            character: event.character,
            theme: event.theme,
          ),
        );
        final jsonStart = responseIA.indexOf('```json');
        final jsonEnd = responseIA.lastIndexOf('```');

        final message = responseIA.substring(0, jsonStart).trim();
        final jsonString = responseIA.substring(jsonStart + 7, jsonEnd).trim();

        final Map<String, dynamic> characterData = jsonString.isNotEmpty
            ? Map<String, dynamic>.from(jsonDecode(jsonString))
            : {};
        final List<Map<String, String>> messagesUpdate = [
          {'role': 'IA', 'text': message},
        ];
        emit(
          ChatSuccess(
            newMessage: state.newMessage,
            messages: state.messages,
            messagesRol: messagesUpdate,
            character: characterData,
            messagesGemini: state.messagesGemini,
            messagesAssistant: state.messagesAssistant,
          ),
        );
      } catch (e) {
        emit(
          ChatFailure(
            'Error al iniciar rol: $e',
            newMessage: state.newMessage,
            messages: state.messages,
            messagesRol: state.messagesRol,
            character: state.character,
            messagesGemini: state.messagesGemini,
            messagesAssistant: state.messagesAssistant,
          ),
        );
      }
    });

    on<CleanRolPlay>((event, emit) {
      emit(
        ChatSuccess(
          newMessage: state.newMessage,
          messages: state.messages,
          messagesRol: const [],
          character: const {},
          messagesGemini: state.messagesGemini,
          messagesAssistant: state.messagesAssistant,
        ),
      );
    });

    on<OnRolPlaySendMessage>((event, emit) async {
      emit(
        ChatLoading(
          newMessage: state.newMessage,
          messages: state.messages,
          messagesRol: state.messagesRol,
          character: state.character,
          messagesGemini: state.messagesGemini,
          messagesAssistant: state.messagesAssistant,
        ),
      );
      final List<Map<String, String>> messagesUpdate =
          List.from(state.messagesRol)
            ..add({'role': 'user', 'text': event.message});
      emit(
        ChatSuccess(
          newMessage: state.newMessage,
          messages: state.messages,
          messagesRol: messagesUpdate,
          character: state.character,
          messagesGemini: state.messagesGemini,
          messagesAssistant: state.messagesAssistant,
        ),
      );
      emit(
        ChatLoading(
          newMessage: state.newMessage,
          messages: state.messages,
          messagesRol: state.messagesRol,
          character: state.character,
          messagesGemini: state.messagesGemini,
          messagesAssistant: state.messagesAssistant,
        ),
      );
      try {
        final responseIA =
            await sendRolMessageUseCase(SendMessageParams(event.message));

        final jsonStart = responseIA.indexOf('```json');
        final jsonEnd = responseIA.lastIndexOf('```');

        final message = responseIA.substring(0, jsonStart).trim();
        final jsonString = responseIA.substring(jsonStart + 7, jsonEnd).trim();

        final Map<String, dynamic> characterData = jsonString.isNotEmpty
            ? Map<String, dynamic>.from(jsonDecode(jsonString))
            : {};
        final List<Map<String, String>> messagesUpdateIA =
            List.from(state.messagesRol)..add({'role': 'IA', 'text': message});
        emit(
          ChatSuccess(
            newMessage: state.newMessage,
            messages: state.messages,
            messagesRol: messagesUpdateIA,
            character: characterData,
            messagesGemini: state.messagesGemini,
            messagesAssistant: state.messagesAssistant,
          ),
        );
      } catch (e) {
        emit(
          ChatFailure(
            'Error al enviar mensaje de rol: $e',
            newMessage: state.newMessage,
            messages: state.messages,
            messagesRol: state.messagesRol,
            character: state.character,
            messagesGemini: state.messagesGemini,
            messagesAssistant: state.messagesAssistant,
          ),
        );
      }
    });

    on<OnChatGeminiStart>((event, emit) async {
      emit(
        ChatLoading(
          newMessage: state.newMessage,
          messages: state.messages,
          messagesRol: state.messagesRol,
          character: state.character,
          messagesGemini: state.messagesGemini,
          messagesAssistant: state.messagesAssistant,
        ),
      );
      try {
        final responseIA = await startChatGeminiUseCase(Context(event.context));
        final List<Map<String, String>> messagesUpdate = [
          {'role': 'IA', 'text': responseIA},
        ];
        emit(
          ChatSuccess(
            newMessage: state.newMessage,
            messages: state.messages,
            messagesRol: state.messagesRol,
            character: state.character,
            messagesGemini: messagesUpdate,
            messagesAssistant: state.messagesAssistant,
          ),
        );
      } catch (e) {
        emit(
          ChatFailure(
            'Error al iniciar chat Gemini: $e',
            newMessage: state.newMessage,
            messages: state.messages,
            messagesRol: state.messagesRol,
            character: state.character,
            messagesGemini: state.messagesGemini,
            messagesAssistant: state.messagesAssistant,
          ),
        );
      }
    });

    on<OnChatGeminiSendMessage>((event, emit) async {
      emit(
        ChatLoading(
          newMessage: state.newMessage,
          messages: state.messages,
          messagesRol: state.messagesRol,
          character: state.character,
          messagesGemini: state.messagesGemini,
          messagesAssistant: state.messagesAssistant,
        ),
      );
      final List<Map<String, String>> messagesUpdate =
          List.from(state.messagesGemini)
            ..add({'role': 'user', 'text': event.message});
      emit(
        ChatSuccess(
          newMessage: state.newMessage,
          messages: state.messages,
          messagesRol: state.messagesRol,
          character: state.character,
          messagesGemini: messagesUpdate,
          messagesAssistant: state.messagesAssistant,
        ),
      );
      emit(
        ChatLoading(
          newMessage: state.newMessage,
          messages: state.messages,
          messagesRol: state.messagesRol,
          character: state.character,
          messagesGemini: state.messagesGemini,
          messagesAssistant: state.messagesAssistant,
        ),
      );
      try {
        final responseIA = await sendMessageGeminiUseCase(
          SendMessageGeminiParams(event.message, event.imageBytes),
        );
        final List<Map<String, String>> messagesUpdateIA =
            List.from(state.messagesGemini)
              ..add({'role': 'IA', 'text': responseIA});
        emit(
          ChatSuccess(
            newMessage: state.newMessage,
            messages: state.messages,
            messagesRol: state.messagesRol,
            character: state.character,
            messagesGemini: messagesUpdateIA,
            messagesAssistant: state.messagesAssistant,
          ),
        );
      } catch (e) {
        emit(
          ChatFailure(
            'Error al enviar mensaje Gemini: $e',
            newMessage: state.newMessage,
            messages: state.messages,
            messagesRol: state.messagesRol,
            character: state.character,
            messagesGemini: state.messagesGemini,
            messagesAssistant: state.messagesAssistant,
          ),
        );
      }
    });

    on<CleanChatGemini>((event, emit) {
      emit(
        ChatSuccess(
          newMessage: state.newMessage,
          messages: state.messages,
          messagesRol: state.messagesRol,
          character: state.character,
          messagesGemini: const [],
          messagesAssistant: state.messagesAssistant,
        ),
      );
    });

    on<OnChatAssistantStart>((event, emit) async {
      emit(
        ChatLoading(
          newMessage: state.newMessage,
          messages: state.messages,
          messagesRol: state.messagesRol,
          character: state.character,
          messagesGemini: state.messagesGemini,
          messagesAssistant: state.messagesAssistant,
        ),
      );
      try {
        final responseIA =
            await startChatAssistantUsecases(Context(event.context));
        final List<Map<String, String>> messagesUpdate = [
          {'role': 'IA', 'text': responseIA},
        ];
        emit(
          ChatSuccess(
            newMessage: state.newMessage,
            messages: state.messages,
            messagesRol: state.messagesRol,
            character: state.character,
            messagesGemini: state.messagesGemini,
            messagesAssistant: messagesUpdate,
          ),
        );
      } catch (e) {
        emit(
          ChatFailure(
            'Error al iniciar asistente: $e',
            newMessage: state.newMessage,
            messages: state.messages,
            messagesRol: state.messagesRol,
            character: state.character,
            messagesGemini: state.messagesGemini,
            messagesAssistant: state.messagesAssistant,
          ),
        );
      }
    });

    on<OnChatAssistantSendMessage>((event, emit) async {
      emit(
        ChatLoading(
          newMessage: state.newMessage,
          messages: state.messages,
          messagesRol: state.messagesRol,
          character: state.character,
          messagesGemini: state.messagesGemini,
          messagesAssistant: state.messagesAssistant,
        ),
      );
      final List<Map<String, String>> messagesUpdate =
          List.from(state.messagesAssistant)
            ..add({'role': 'user', 'text': event.message});
      emit(
        ChatSuccess(
          newMessage: state.newMessage,
          messages: state.messages,
          messagesRol: state.messagesRol,
          character: state.character,
          messagesGemini: state.messagesGemini,
          messagesAssistant: messagesUpdate,
        ),
      );
      emit(
        ChatLoading(
          newMessage: state.newMessage,
          messages: state.messages,
          messagesRol: state.messagesRol,
          character: state.character,
          messagesGemini: state.messagesGemini,
          messagesAssistant: state.messagesAssistant,
        ),
      );
      try {
        final responseIA = await sendMessageAssistantUsecase(
          SendMessageGeminiParams(event.message, event.imageBytes),
        );
        final List<Map<String, String>> messagesUpdateIA =
            List.from(state.messagesAssistant)
              ..add({'role': 'IA', 'text': responseIA});
        emit(
          ChatSuccess(
            newMessage: state.newMessage,
            messages: state.messages,
            messagesRol: state.messagesRol,
            character: state.character,
            messagesGemini: state.messagesGemini,
            messagesAssistant: messagesUpdateIA,
          ),
        );
      } catch (e) {
        emit(
          ChatFailure(
            'Error al enviar mensaje al asistente: $e',
            newMessage: state.newMessage,
            messages: state.messages,
            messagesRol: state.messagesRol,
            character: state.character,
            messagesGemini: state.messagesGemini,
            messagesAssistant: state.messagesAssistant,
          ),
        );
      }
    });

    on<CleanChatAssistant>((event, emit) {
      emit(
        ChatSuccess(
          newMessage: state.newMessage,
          messages: state.messages,
          messagesRol: state.messagesRol,
          character: state.character,
          messagesGemini: state.messagesGemini,
          messagesAssistant: const [],
        ),
      );
    });
  }
}
