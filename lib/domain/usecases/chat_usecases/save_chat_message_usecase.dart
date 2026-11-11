import 'package:roll_and_reserve/core/use_case.dart';
import 'package:roll_and_reserve/domain/entities/chat_message_entity.dart';
import 'package:roll_and_reserve/domain/repositories/chat_repository.dart';

class SaveChatMessageUseCase implements UseCase<void, ChatMessageEntity> {
  final ChatRepository repository;

  SaveChatMessageUseCase(this.repository);

  @override
  Future<void> call(ChatMessageEntity params) async {
    return await repository.saveChatMessage(params);
  }
}
