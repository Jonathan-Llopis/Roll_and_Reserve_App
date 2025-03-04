import 'package:roll_and_reserve/core/use_case.dart';
import 'package:roll_and_reserve/domain/repositories/chat_repository.dart';

class StartChatUseCase implements UseCase<dynamic, NoParams> {
  final ChatRepository repository;
  StartChatUseCase(this.repository);

  @override
  Future<dynamic> call(NoParams params) async {
   
      return await repository.startChat();
    
  }
}