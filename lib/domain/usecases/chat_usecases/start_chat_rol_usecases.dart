import 'package:roll_and_reserve/core/use_case.dart';
import 'package:roll_and_reserve/domain/repositories/chat_repository.dart';

class StartChatRolUseCase implements UseCase<String, StartRolPlayParams> {
  final ChatRepository repository;
  StartChatRolUseCase(this.repository);

  @override
  Future<String> call(StartRolPlayParams params) async {
    return await repository.startRolPlay(params.context, params.character);
  }
}
