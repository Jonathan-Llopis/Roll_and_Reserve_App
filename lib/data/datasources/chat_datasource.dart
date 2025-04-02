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
  Future<String> startChatAssistant(String prompt);
  Future<String> sendMessageAssitant(String message, List<ByteData>? imageBytes);
}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  ChatRemoteDataSourceImpl() {
    _initializeDeepSeek();
  }

  late final DeepSeek deepSeek;
  late List<Message> chatHistory;
  late List<Message> rolePlayHistory;

  /// Initializes the DeepSeek AI service with the API key found in the environment variables.
  ///
  /// If the API key is not found, throws an exception.
  ///
  /// Also, initializes the chat history and role play history to empty lists.
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
  /// Initiates a chat session by sending a user message to the DeepSeek AI service.
  ///
  /// Clears the chat history and adds the user's message to it. Sends the message
  /// to the DeepSeek service, waiting for an assistant's response.
  ///
  /// Returns the assistant's response as a string if successful.
  ///
  /// Throws an exception if the response is empty or if there is an error while
  /// interacting with the DeepSeek service.

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
  /// Sends a message to the DeepSeek AI service to continue a chat session.
  ///
  /// Before calling this method, the chat session must be initialized by calling
  /// [startChat]. If not, throws an exception.
  ///
  /// Adds the user's message to the chat history and sends it to the DeepSeek
  /// service, waiting for an assistant's response.
  ///
  /// Returns the assistant's response as a string if successful.
  ///
  /// Throws an exception if the response is empty or if there is an error while
  /// interacting with the DeepSeek service.
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
  /// Starts a role play chat session with the DeepSeek AI service.
  ///
  /// A role play chat session is a special type of chat session where the AI
  /// service acts as a character in the context of a story or scenario provided
  /// by the user. The AI service will generate a response based on the scenario
  /// and the user's message.
  ///
  /// The [prompt] parameter must be a string describing the scenario and the
  /// character the AI service should act as.
  ///
  /// Returns the AI service response as a string if successful.
  ///
  /// Throws an exception if the response is empty or if there is an error while
  /// interacting with the DeepSeek service.
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
  /// Sends a message to the DeepSeek AI service as part of a role play session.
  ///
  /// A role play session is a special type of chat session where the AI service
  /// acts as a character in the context of a story or scenario provided by the
  /// user. The AI service will generate a response based on the scenario and the
  /// user's message.
  ///
  /// The [message] parameter is the message to be sent to the AI service.
  ///
  /// Returns the AI service response as a string if successful.
  ///
  /// Throws an exception if the response is empty or if there is an error while
  /// interacting with the DeepSeek service.
  ///
  /// Before calling this method, you must call [startRolPlay] to start the role
  /// play session.
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
  /// Starts a chat session with the AI service using the Gemini model.
  ///
  /// The [prompt] parameter is the initial message to be sent to the AI service.
  ///
  /// Returns the AI service response as a string if successful.
  ///
  /// Throws an exception if the response is empty or if there is an error while
  /// interacting with the AI service.
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
  /// Sends a message to the AI service using the Gemini model.
  ///
  /// The [message] parameter is the text message to be sent to the AI service.
  ///
  /// The [imageBytes] parameter is a list of ByteData objects representing the
  /// images to be sent to the AI service. If the list is not empty, the message
  /// will be sent as a multi-part message with the text and images.
  ///
  /// Returns the AI service response as a string if successful.
  ///
  /// Throws an exception if the response is empty or if there is an error while
  /// interacting with the AI service.
  ///
  /// Before calling this method, you must call [startChatGemini] to start the
  /// chat session.
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

  @override
  /// Starts a chat session with the AI service using the assistant model.
  ///
  /// The [prompt] parameter is the initial message to be sent to the AI service.
  ///
  /// Returns the AI service response as a string if successful.
  ///
  /// Throws an exception if the response is empty or if there is an error while
  /// interacting with the AI service.
  Future<String> startChatAssistant(String prompt) async {
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
  /// Sends a message to the AI service using the assistant model.
  ///
  /// The [message] parameter is the text message to be sent to the AI service.
  ///
  /// The [imageBytes] parameter is a list of ByteData objects representing the
  /// images to be sent to the AI service. If the list is not empty, the message
  /// will be sent as a multi-part message with the text and images.
  ///
  /// Returns the AI service response as a string if successful.
  ///
  /// Throws an exception if the response is empty or if there is an error while
  /// interacting with the AI service.

  Future<String> sendMessageAssitant(String message, List<ByteData>? imageBytes) async {
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
