import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:deepseek/deepseek.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

abstract class ChatRemoteDataSource {
  Future<String> startChat(String message);
  Future<String> sendMessage(String message);
  Future<String> startRolPlay(String prompt);
  Future<String> sendRolPlay(String message);
  Future<String> startChatGemini(String prompt);
  Future<String> sendMessageGemini(String message, List<ByteData>? imageBytes);
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
      throw Exception(
          'DEEP_SEEK_API_KEY is not set in the environment variables.');
    }
    deepSeek = DeepSeek(apiKey);
    chatHistory = [];
    rolePlayHistory = [];
  }

  @override
  Future<String> startChat(String message) async {
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
        chatHistory.add(Message(
            role: "assistant",
            content: utf8.decode(latin1.encode(response.text))));
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
        chatHistory.add(Message(
            role: "assistant",
            content: utf8.decode(latin1.encode(response.text))));
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
        rolePlayHistory.add(Message(
            role: "assistant",
            content: utf8.decode(latin1.encode(response.text))));
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
      throw Exception(
          'Role play session not initialized. Call startRolePlay first.');
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
        rolePlayHistory.add(Message(
            role: "assistant",
            content: utf8.decode(latin1.encode(response.text))));
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

  final model = GenerativeModel(
    model: 'gemini-2.0-flash',
    apiKey: dotenv.env['OPENAI_API_KEY']!,
  );

  late dynamic chat;

  @override
  Future<String> startChatGemini(String prompt) async {
    chat = model.startChat();
    final content = [Content.text(prompt)];
    final response = await chat.sendMessage(content.first);

    if (response.text != '') {
      return response.text.toString();
    } else {
      throw Exception('Error al iniciar el Chat.');
    }
  }
  @override
  Future<String> sendMessageGemini(String message, List<ByteData>? imageBytes) async {
    List<Content> content = [Content.text(message)];

    if (imageBytes != null && imageBytes.isNotEmpty) {
      List<DataPart> dataParts = imageBytes.map((byteData) {
        return DataPart('image/jpeg', byteData.buffer.asUint8List());
      }).toList();
      content = [Content.multi([TextPart(message), ...dataParts])];
    }

    final response = await chat.sendMessage(content.first);

    if (response.text.isNotEmpty) {
      return response.text.toString();
    } else {
      throw Exception('Error al enviar el mensaje.');
    }
  }
  
}
