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
        final chat = await startChatUseCase(NoParams());
        emit(ChatState.success(state, chat));
      } catch (e) {
        emit(state.copyWith(isLoading: false));
      }
    });

    on<OnChatSendMessage>((event, emit) async {
      emit(ChatState.loading(state));
      try {
        final chat = await sendMessageUseCase(SendMessageParams(event.message));
        emit(ChatState.success(state, chat));
      } catch (e) {
        emit(state.copyWith(isLoading: false));
      }
    });
  }
}