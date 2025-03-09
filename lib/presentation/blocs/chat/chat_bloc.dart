import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:roll_and_reserve/core/use_case.dart';
import 'package:roll_and_reserve/domain/usecases/chat_usecases/send_message_usecase.dart';
import 'package:roll_and_reserve/domain/usecases/chat_usecases/start_chat_usecases.dart';
import 'package:roll_and_reserve/presentation/blocs/chat/chat_event.dart';
import 'package:roll_and_reserve/presentation/blocs/chat/chat_state.dart';


class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final StartChatUseCase startChatUseCase;
  final SendMessageUseCase sendMessageUseCase;

  ChatBloc(
     this.startChatUseCase,
     this.sendMessageUseCase,
  ) : super(ChatState.initial()) {
    on<OnChatStart>((event, emit) async {
      emit(ChatState.loading(state));
      try {
        final responseIA = await startChatUseCase(Context(event.context));
        final List<Map<String, String>> messagesUpdate = [{'role': 'IA', 'text': responseIA}];
        emit(ChatState.success(state, messagesUpdate));
      } catch (e) {
        emit(state.copyWith(isLoading: false));
      }
    });

    on<OnChatSendMessage>((event, emit) async {
      emit(ChatState.loading(state));
      final List<Map<String, String>> messagesUpdate  = List.from(state.messages)..add({'role': 'user', 'text': event.message});
      emit(ChatState.userMessage(state, messagesUpdate));
      emit(ChatState.loading(state));
      try {
      final responseIA = await sendMessageUseCase(SendMessageParams(event.message));
      final List<Map<String, String>> messagesUpdateIA  = List.from(state.messages)..add({'role': 'IA', 'text': responseIA});
      emit(ChatState.success(state, messagesUpdateIA));
      } catch (e) {
      emit(state.copyWith(isLoading: false));
      }
    });
  }
}