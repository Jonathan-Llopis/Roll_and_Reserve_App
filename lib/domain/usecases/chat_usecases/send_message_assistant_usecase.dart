import 'package:roll_and_reserve/core/use_case.dart';
import 'package:roll_and_reserve/domain/repositories/chat_repository.dart';

class SendMessageAssistantUsecase implements UseCase<String, SendMessageGeminiParams> {
  final ChatRepository repository;
  SendMessageAssistantUsecase(this.repository);

  @override
  Future<String> call(SendMessageGeminiParams params) async {
    return repository.sendMessageAssitant(params.message, imageBytes: params.imageBytes);
  }
}

