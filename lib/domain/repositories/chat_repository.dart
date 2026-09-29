import 'dart:typed_data';

abstract class ChatRepository {
  Future<String> startChat(String message);
  Future<String> sendMessage(String message);
  Future<String> startRolPlay(
    String character,
    String theme, [
    String languageCode,
  ]);
  Future<String> sendRolPlay(String message);
  Future<String> startChatGemini([String languageCode]);
  Future<String> sendMessageGemini(
    String message, {
    List<ByteData>? imageBytes,
  });
  Future<String> startChatAssistant([String languageCode]);
  Future<String> sendMessageAssitant(
    String message, {
    List<ByteData>? imageBytes,
  });
}
