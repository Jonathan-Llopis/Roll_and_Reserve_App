import 'package:roll_and_reserve/core/use_case.dart';
import 'package:roll_and_reserve/domain/repositories/chat_repository.dart';

class StartChatUseCase implements UseCase<String, StartChatParams> {
  final ChatRepository repository;
  StartChatUseCase(this.repository);

  @override
  Future<String> call(StartChatParams params) async {
   
      return await repository.startChat(params.context, params.message);
    
  }
}