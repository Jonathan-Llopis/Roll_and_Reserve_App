import 'package:roll_and_reserve/core/use_case.dart';
import 'package:roll_and_reserve/domain/repositories/chat_repository.dart';

class SendMessageUseCase implements UseCase<String, SendMessageParams> {
  final ChatRepository repository;
  SendMessageUseCase(this.repository);

  @override
  Future<String> call(SendMessageParams params) async {
    return repository.sendMessage(params.message);
  }
}

