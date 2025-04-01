import 'package:roll_and_reserve/core/use_case.dart';
import 'package:roll_and_reserve/domain/repositories/chat_repository.dart';

class StartChatAssistantUsecases implements UseCase<String, Context> {
  final ChatRepository repository;
  StartChatAssistantUsecases(this.repository);

  @override
  Future<String> call(Context params) async {
   
      return await repository.startChatAssistant(params.context);
    
  }
}