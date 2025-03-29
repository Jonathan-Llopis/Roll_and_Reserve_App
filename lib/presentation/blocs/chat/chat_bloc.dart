import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:roll_and_reserve/core/use_case.dart';
import 'package:roll_and_reserve/domain/usecases/chat_usecases/send_message_usecase.dart';
import 'package:roll_and_reserve/domain/usecases/chat_usecases/send_rol_message_usecase.dart';
import 'package:roll_and_reserve/domain/usecases/chat_usecases/start_chat_rol_usecases.dart';
import 'package:roll_and_reserve/domain/usecases/chat_usecases/start_chat_usecases.dart';
import 'package:roll_and_reserve/presentation/blocs/chat/chat_event.dart';
import 'package:roll_and_reserve/presentation/blocs/chat/chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final StartChatUseCase startChatUseCase;
  final SendMessageUseCase sendMessageUseCase;
  final StartChatRolUseCase startChatRolUseCase;
  final SendRolMessageUseCase sendRolMessageUseCase;

  ChatBloc(
    this.startChatUseCase,
    this.sendMessageUseCase,
    this.startChatRolUseCase,
    this.sendRolMessageUseCase,
  ) : super(ChatState.initial()) {
    on<OnChatStart>((event, emit) async {
      emit(ChatState.loading(state));
      try {
        List<Map<String, String>> messagesUpdate = [
          {'role': 'user', 'text': event.message}
        ];
        emit(ChatState.userMessage(state, messagesUpdate));
        emit(ChatState.loading(state));
        final responseIA = await startChatUseCase(
            StartChatParams(event.context, message: event.message));
        messagesUpdate.add({'role': 'IA', 'text': responseIA});
        emit(ChatState.success(state, messagesUpdate));
      } catch (e) {
        emit(state.copyWith(isLoading: false));
      }
    });

    on<OnChatSendMessage>((event, emit) async {
      emit(ChatState.loading(state));
      final List<Map<String, String>> messagesUpdate = List.from(state.messages)
        ..add({'role': 'user', 'text': event.message});
      emit(ChatState.userMessage(state, messagesUpdate));
      emit(ChatState.loading(state));
      try {
        final responseIA =
            await sendMessageUseCase(SendMessageParams(event.message));
        final List<Map<String, String>> messagesUpdateIA =
            List.from(state.messages)..add({'role': 'IA', 'text': responseIA});
        emit(ChatState.success(state, messagesUpdateIA));
      } catch (e) {
        emit(state.copyWith(isLoading: false));
      }
    });
    on<CleanChat>((event, emit) {
      emit(ChatState.clean(state));
    });
    on<OnRolPlayStart>((event, emit) async {
      emit(ChatState.loading(state));
      try {
        final responseIA = await startChatRolUseCase(
            StartRolPlayParams(event.context, character: event.character));
        final List<Map<String, String>> messagesUpdate = [];
        final jsonStart = responseIA.indexOf('```json');
        final jsonEnd = responseIA.lastIndexOf('```');

        final message = responseIA.substring(0, jsonStart).trim();
        final jsonString = responseIA.substring(jsonStart + 7, jsonEnd).trim();

        final Map<String, dynamic> characterData = jsonString.isNotEmpty
            ? Map<String, dynamic>.from(jsonDecode(jsonString))
            : {};
        messagesUpdate.add({'role': 'IA', 'text': message});
        emit(ChatState.rolMessage(state, messagesUpdate, characterData));
      } catch (e) {
        emit(state.copyWith(isLoading: false));
      }
    });

    on<OnRolPlaySendMessage>((event, emit) async {
      emit(ChatState.loading(state));
      final List<Map<String, String>> messagesUpdate =
          List.from(state.messagesRol)
            ..add({'role': 'user', 'text': event.message});
      emit(ChatState.rolUserMessage(state, messagesUpdate));
      emit(ChatState.loading(state));
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
            List.from(state.messagesRol)
              ..add({'role': 'IA', 'text': message});
        emit(ChatState.rolMessage(state, messagesUpdateIA, characterData));
      } catch (e) {
        emit(state.copyWith(isLoading: false));
      }
    });
    on<CleanRolPlay>((event, emit) {
      emit(ChatState.clean(state));
    });
  }
}
