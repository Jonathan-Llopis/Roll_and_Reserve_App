import 'package:roll_and_reserve/core/use_case.dart';
import 'package:roll_and_reserve/domain/entities/chat_message_entity.dart';
import 'package:roll_and_reserve/domain/repositories/chat_repository.dart';

class GetChatHistoryParams {
  final String sessionId;
  GetChatHistoryParams({required this.sessionId});
}

class GetChatHistoryUseCase implements UseCase<List<ChatMessageEntity>, GetChatHistoryParams> {
  final ChatRepository repository;

  GetChatHistoryUseCase(this.repository);

  @override
  Future<List<ChatMessageEntity>> call(GetChatHistoryParams params) async {
    return await repository.getChatHistory(params.sessionId);
  }
}
