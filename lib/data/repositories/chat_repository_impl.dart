import 'dart:typed_data';

import 'package:roll_and_reserve/data/datasources/ai/prompts/prompt.dart';
import 'package:roll_and_reserve/data/datasources/ai/prompts/prompt_asistente.dart';
import 'package:roll_and_reserve/data/datasources/ai/prompts/rol_prompt.dart';
import 'package:roll_and_reserve/data/datasources/chat_datasource.dart';
import 'package:roll_and_reserve/data/datasources/chat_local_datasource.dart';
import 'package:roll_and_reserve/domain/entities/chat_message_entity.dart';
import 'package:roll_and_reserve/domain/repositories/chat_repository.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource remoteDataSource;
  final ChatLocalDataSource localDataSource;

  ChatRepositoryImpl(
    this.remoteDataSource, {
    ChatLocalDataSource? localDataSource,
  }) : localDataSource = localDataSource ?? ChatLocalDataSourceImpl();

  @override
  Future<String> startChat(String message) async {
    try {
      return await remoteDataSource.startChat(message);
    } catch (e) {
      throw Exception('Error starting chat: $e');
    }
  }

  @override
  Future<String> sendMessage(String message) async {
    try {
      return await remoteDataSource.sendMessage(message);
    } catch (e) {
      throw Exception('Error sending message: $e');
    }
  }

  @override
  Future<String> startRolPlay(
    String character,
    String theme, [
    String languageCode = 'es',
  ]) async {
    try {
      String prompt = getLocalizedPrompt(character, theme, languageCode);
      return await remoteDataSource.startRolPlay(prompt);
    } catch (e) {
      throw Exception('Error starting rol play: $e');
    }
  }

  @override
  Future<String> sendRolPlay(String message) async {
    try {
      return await remoteDataSource.sendRolPlay(message);
    } catch (e) {
      throw Exception('Error sending rol play: $e');
    }
  }

  @override
  Future<String> startChatGemini([String languageCode = 'es']) async {
    try {
      String prompt = getGeminiPrompt(languageCode);
      return await remoteDataSource.startChatGemini(prompt);
    } catch (e) {
      throw Exception('Error starting chat gemini: $e');
    }
  }

  @override
  Future<String> sendMessageGemini(
    String message, {
    List<ByteData>? imageBytes,
  }) async {
    try {
      return await remoteDataSource.sendMessageGemini(message, imageBytes);
    } catch (e) {
      throw Exception('Error sending message gemini: $e');
    }
  }

  @override
  Future<String> startChatAssistant([String languageCode = 'es']) async {
    try {
      String prompt = getAssistantPrompt(languageCode);
      return await remoteDataSource.startChatAssistant(prompt);
    } catch (e) {
      throw Exception('Error starting chat assistant: $e');
    }
  }

  @override
  Future<String> sendMessageAssistant(
    String message, {
    List<ByteData>? imageBytes,
  }) async {
    try {
      return await remoteDataSource.sendMessageAssistant(message, imageBytes);
    } catch (e) {
      throw Exception('Error sending message assistant: $e');
    }
  }

  @override
  @Deprecated('Use sendMessageAssistant instead')
  Future<String> sendMessageAssitant(
    String message, {
    List<ByteData>? imageBytes,
  }) => sendMessageAssistant(message, imageBytes: imageBytes);

  @override
  Future<List<ChatMessageEntity>> getChatHistory(String sessionId) async {
    return await localDataSource.getMessages(sessionId);
  }

  @override
  Future<void> saveChatMessage(ChatMessageEntity message) async {
    await localDataSource.saveMessage(message);
  }

  @override
  Future<void> clearChatHistory([String? sessionId]) async {
    await localDataSource.clearHistory(sessionId);
  }
}
