import 'package:roll_and_reserve/core/use_case.dart';
import 'package:roll_and_reserve/domain/repositories/chat_repository.dart';

class ClearChatHistoryParams {
  final String? sessionId;
  ClearChatHistoryParams({this.sessionId});
}

class ClearChatHistoryUseCase implements UseCase<void, ClearChatHistoryParams> {
  final ChatRepository repository;

  ClearChatHistoryUseCase(this.repository);

  @override
  Future<void> call(ClearChatHistoryParams params) async {
    return await repository.clearChatHistory(params.sessionId);
  }
}
