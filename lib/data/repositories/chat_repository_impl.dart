import 'dart:typed_data';

import 'package:roll_and_reserve/core/prompt.dart';
import 'package:roll_and_reserve/core/prompt_asistente.dart';
import 'package:roll_and_reserve/core/rol_prompt/prompt.dart';
import 'package:roll_and_reserve/data/datasources/chat_datasource.dart';
import 'package:roll_and_reserve/domain/repositories/chat_repository.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource remoteDataSource;

  ChatRepositoryImpl(this.remoteDataSource);

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
  Future<String> sendMessageAssitant(
    String message, {
    List<ByteData>? imageBytes,
  }) async {
    try {
      return await remoteDataSource.sendMessageAssitant(message, imageBytes);
    } catch (e) {
      throw Exception('Error sending message assistant: $e');
    }
  }
}
