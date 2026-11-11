import 'dart:typed_data';
import 'package:roll_and_reserve/domain/entities/chat_message_entity.dart';

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
  Future<String> sendMessageAssistant(
    String message, {
    List<ByteData>? imageBytes,
  });
  @Deprecated('Use sendMessageAssistant instead')
  Future<String> sendMessageAssitant(
    String message, {
    List<ByteData>? imageBytes,
  });
  Future<List<ChatMessageEntity>> getChatHistory(String sessionId);
  Future<void> saveChatMessage(ChatMessageEntity message);
  Future<void> clearChatHistory([String? sessionId]);
}
