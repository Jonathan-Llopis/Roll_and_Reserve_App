import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:deepseek/deepseek.dart';

abstract class ChatRemoteDataSource {
  Future<String> startChat( String message);
  Future<String> sendMessage(String message);
  Future<String> startRolPlay(String prompt);
  Future<String> sendRolPlay(String message);
}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  ChatRemoteDataSourceImpl() {
    _initializeDeepSeek();
  }

  late final DeepSeek deepSeek;
  late List<Message> chatHistory;
  late List<Message> rolePlayHistory;

  void _initializeDeepSeek() {
    final apiKey = dotenv.env['DEEP_SEEK_API_KEY'];
    if (apiKey == null || apiKey.isEmpty) {
      throw Exception('DEEP_SEEK_API_KEY is not set in the environment variables.');
    }
    deepSeek = DeepSeek(apiKey);
    chatHistory = [];
    rolePlayHistory = [];
  }

  @override
  Future<String> startChat( String message) async {
    chatHistory.clear();
    chatHistory.add(Message(role: "user", content: message));

    try {
      final response = await deepSeek.createChat(
        messages: chatHistory,
        model: Models.reasoner.name,
        options: {
          "temperature": 1.0,
          "max_tokens": 4096,
        },
      );

      if (response.text.isNotEmpty) {
        chatHistory.add(Message(role: "assistant", content: utf8.decode(latin1.encode(response.text))));
        return utf8.decode(latin1.encode(response.text));
      } else {
        throw Exception('Failed to start chat.');
      }
    } on DeepSeekException catch (e) {
      throw Exception('DeepSeek API error: ${e.statusCode}:${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  @override
  Future<String> sendMessage(String message) async {
    if (chatHistory.isEmpty) {
      throw Exception('Chat session not initialized. Call startChat first.');
    }

    chatHistory.add(Message(role: "user", content: message));

    try {
      final response = await deepSeek.createChat(
        messages: chatHistory,
        model: Models.reasoner.name,
        options: {
          "temperature": 1.0,
          "max_tokens": 4096,

        },
      );

      if (response.text.isNotEmpty) {
        chatHistory.add(Message(role: "assistant", content: utf8.decode(latin1.encode(response.text))));
        return utf8.decode(latin1.encode(response.text));
      } else {
        throw Exception('Failed to send message.');
      }
    } on DeepSeekException catch (e) {
      throw Exception('DeepSeek API error: ${e.statusCode}:${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  @override
  Future<String> startRolPlay(String prompt) async {
    rolePlayHistory.clear();
    rolePlayHistory.add(Message(role: "user", content: prompt));

    try {
      final response = await deepSeek.createChat(
        messages: rolePlayHistory,
        model: Models.chat.name,
        options: {
          "temperature": 1.0,
          "max_tokens": 4096,
        },
      );

      if (response.text.isNotEmpty) {
        rolePlayHistory.add(Message(role: "assistant", content: utf8.decode(latin1.encode(response.text))));
        return utf8.decode(latin1.encode(response.text));
      } else {
        throw Exception('Failed to start role play.');
      }
    } on DeepSeekException catch (e) {
      throw Exception('DeepSeek API error: ${e.statusCode}:${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  @override 
  Future<String> sendRolPlay(String message) async {
    if (rolePlayHistory.isEmpty) {
      throw Exception('Role play session not initialized. Call startRolePlay first.');
    }

    rolePlayHistory.add(Message(role: "user", content: message));

    try {
      final response = await deepSeek.createChat(
        messages: rolePlayHistory,
        model: Models.chat.name,
        options: {
          "temperature": 1.0,
          "max_tokens": 4096,
        },
      );

      if (response.text.isNotEmpty) {
        rolePlayHistory.add(Message(role: "assistant", content: utf8.decode(latin1.encode(response.text))));
        return utf8.decode(latin1.encode(response.text));
      } else {
        throw Exception('Failed to send role play message.');
      }
    } on DeepSeekException catch (e) {
      throw Exception('DeepSeek API error: ${e.statusCode}:${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

}