import 'package:roll_and_reserve/core/use_case.dart';
import 'package:roll_and_reserve/domain/repositories/chat_repository.dart';

class SendMessageGeminiUsecase implements UseCase<String, SendMessageGeminiParams> {
  final ChatRepository repository;
  SendMessageGeminiUsecase(this.repository);

  @override
  Future<String> call(SendMessageGeminiParams params) async {
    return repository.sendMessageGemini(params.message, imageBytes: params.imageBytes);
  }
}

