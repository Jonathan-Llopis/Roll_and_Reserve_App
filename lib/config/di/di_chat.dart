import 'package:get_it/get_it.dart';
import 'package:roll_and_reserve/data/datasources/chat_datasource.dart';
import 'package:roll_and_reserve/data/datasources/chat_local_datasource.dart';
import 'package:roll_and_reserve/data/repositories/chat_repository_impl.dart';
import 'package:roll_and_reserve/domain/repositories/chat_repository.dart';
import 'package:roll_and_reserve/domain/usecases/chat_usecases/clear_chat_history_usecase.dart';
import 'package:roll_and_reserve/domain/usecases/chat_usecases/get_chat_history_usecase.dart';
import 'package:roll_and_reserve/domain/usecases/chat_usecases/save_chat_message_usecase.dart';
import 'package:roll_and_reserve/domain/usecases/chat_usecases/send_message_assistant_usecase.dart';
import 'package:roll_and_reserve/domain/usecases/chat_usecases/send_message_gemini_usecase.dart';
import 'package:roll_and_reserve/domain/usecases/chat_usecases/send_message_usecase.dart';
import 'package:roll_and_reserve/domain/usecases/chat_usecases/send_rol_message_usecase.dart';
import 'package:roll_and_reserve/domain/usecases/chat_usecases/start_chat_assistant_usecases.dart';
import 'package:roll_and_reserve/domain/usecases/chat_usecases/start_chat_gemini_usecases.dart';
import 'package:roll_and_reserve/domain/usecases/chat_usecases/start_chat_rol_usecases.dart';
import 'package:roll_and_reserve/domain/usecases/chat_usecases/start_chat_usecases.dart';
import 'package:roll_and_reserve/presentation/blocs/chat/chat_bloc.dart';

void registerChatDependencies(GetIt sl) {
  // Data Sources
  sl.registerLazySingleton<ChatRemoteDataSource>(
    () => ChatRemoteDataSourceImpl(),
  );
  sl.registerLazySingleton<ChatLocalDataSource>(
    () => ChatLocalDataSourceImpl(),
  );

  // Repository
  sl.registerLazySingleton<ChatRepository>(
    () => ChatRepositoryImpl(
      sl<ChatRemoteDataSource>(),
      localDataSource: sl<ChatLocalDataSource>(),
    ),
  );

  // Use Cases
  sl.registerLazySingleton<StartChatUseCase>(
    () => StartChatUseCase(sl<ChatRepository>()),
  );
  sl.registerLazySingleton<SendMessageUseCase>(
    () => SendMessageUseCase(sl<ChatRepository>()),
  );
  sl.registerLazySingleton<StartChatRolUseCase>(
    () => StartChatRolUseCase(sl<ChatRepository>()),
  );
  sl.registerLazySingleton<SendRolMessageUseCase>(
    () => SendRolMessageUseCase(sl<ChatRepository>()),
  );
  sl.registerLazySingleton<StartChatGeminiUsecases>(
    () => StartChatGeminiUsecases(sl<ChatRepository>()),
  );
  sl.registerLazySingleton<SendMessageGeminiUsecase>(
    () => SendMessageGeminiUsecase(sl<ChatRepository>()),
  );
  sl.registerLazySingleton<StartChatAssistantUsecases>(
    () => StartChatAssistantUsecases(sl<ChatRepository>()),
  );
  sl.registerLazySingleton<SendMessageAssistantUsecase>(
    () => SendMessageAssistantUsecase(sl<ChatRepository>()),
  );
  sl.registerLazySingleton<GetChatHistoryUseCase>(
    () => GetChatHistoryUseCase(sl<ChatRepository>()),
  );
  sl.registerLazySingleton<SaveChatMessageUseCase>(
    () => SaveChatMessageUseCase(sl<ChatRepository>()),
  );
  sl.registerLazySingleton<ClearChatHistoryUseCase>(
    () => ClearChatHistoryUseCase(sl<ChatRepository>()),
  );

  // BLoC
  sl.registerFactory<ChatBloc>(
    () => ChatBloc(
      startChatUseCase: sl<StartChatUseCase>(),
      sendMessageUseCase: sl<SendMessageUseCase>(),
      startChatRolUseCase: sl<StartChatRolUseCase>(),
      sendRolMessageUseCase: sl<SendRolMessageUseCase>(),
      startChatGeminiUseCase: sl<StartChatGeminiUsecases>(),
      sendMessageGeminiUseCase: sl<SendMessageGeminiUsecase>(),
      startChatAssistantUsecases: sl<StartChatAssistantUsecases>(),
      sendMessageAssistantUsecase: sl<SendMessageAssistantUsecase>(),
      getChatHistoryUseCase: sl<GetChatHistoryUseCase>(),
      saveChatMessageUseCase: sl<SaveChatMessageUseCase>(),
      clearChatHistoryUseCase: sl<ClearChatHistoryUseCase>(),
    ),
  );
}
