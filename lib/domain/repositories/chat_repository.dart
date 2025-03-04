abstract class ChatRepository {
  Future<dynamic> startChat();
  Future<dynamic> sendMessage(String message);
}