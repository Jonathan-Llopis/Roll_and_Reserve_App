import 'dart:typed_data';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

abstract class ChatRemoteDataSource {
  Future<String> startChat(String message);
  Future<String> sendMessage(String message);
  Future<String> startRolPlay(String prompt);
  Future<String> sendRolPlay(String message);
  Future<String> startChatGemini(String prompt);
  Future<String> sendMessageGemini(String message, List<ByteData>? imageBytes);
  Future<String> startChatAssistant(String prompt);
  Future<String> sendMessageAssistant(
    String message,
    List<ByteData>? imageBytes,
  );
  @Deprecated('Use sendMessageAssistant instead')
  Future<String> sendMessageAssitant(
    String message,
    List<ByteData>? imageBytes,
  );
}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  ChatRemoteDataSourceImpl();

  List<Map<String, String>> chatHistory = [];
  List<Map<String, String>> rolePlayHistory = [];

  @override
  Future<String> startChat(String message) async {
    chatHistory = [
      {'role': 'user', 'content': message},
      {'role': 'assistant', 'content': 'Chat general deprecado. Por favor, usa el nuevo Árbitro de Reglas con GenUI.'},
    ];
    return chatHistory.last['content']!;
  }

  @override
  Future<String> sendMessage(String message) async {
    chatHistory.add({'role': 'user', 'content': message});
    const reply = 'Chat general deprecado. Por favor, usa el nuevo Árbitro de Reglas con GenUI.';
    chatHistory.add({'role': 'assistant', 'content': reply});
    return reply;
  }

  @override
  Future<String> startRolPlay(String prompt) async {
    rolePlayHistory = [
      {'role': 'system', 'content': prompt},
      {'role': 'assistant', 'content': 'Modo rol deprecado. Por favor, usa el nuevo Árbitro de Reglas con GenUI.'},
    ];
    return rolePlayHistory.last['content']!;
  }

  @override
  Future<String> sendRolPlay(String message) async {
    rolePlayHistory.add({'role': 'user', 'content': message});
    const reply = 'Modo rol deprecado. Por favor, usa el nuevo Árbitro de Reglas con GenUI.';
    rolePlayHistory.add({'role': 'assistant', 'content': reply});
    return reply;
  }

  GenerativeModel? _generativeModel;
  ChatSession? _geminiChat;
  ChatSession? _assistantChat;

  GenerativeModel get _model {
    if (_generativeModel != null) return _generativeModel!;
    final apiKey = dotenv.env['GEMINI_API_KEY'] ??
        dotenv.env['GOOGLE_API_KEY'] ??
        dotenv.env['OPENAI_API_KEY'];
    if (apiKey == null || apiKey.isEmpty) {
      throw Exception(
        'GEMINI_API_KEY is not set in the environment variables.',
      );
    }
    _generativeModel = GenerativeModel(
      model: 'gemini-2.0-flash',
      apiKey: apiKey,
    );
    return _generativeModel!;
  }

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
    _geminiChat = _model.startChat();
    final content = [Content.text(prompt)];
    final response = await _geminiChat!.sendMessage(content.first);

    if (response.text != null && response.text!.isNotEmpty) {
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
  Future<String> sendMessageGemini(
    String message,
    List<ByteData>? imageBytes,
  ) async {
    _geminiChat ??= _model.startChat();
    List<Content> content = [Content.text(message)];

    if (imageBytes != null && imageBytes.isNotEmpty) {
      List<DataPart> dataParts = imageBytes.map((byteData) {
        return DataPart('image/jpeg', byteData.buffer.asUint8List());
      }).toList();
      content = [
        Content.multi([TextPart(message), ...dataParts]),
      ];
    }

    final response = await _geminiChat!.sendMessage(content.first);

    if (response.text != null && response.text!.isNotEmpty) {
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
    _assistantChat = _model.startChat();
    final content = [Content.text(prompt)];
    final response = await _assistantChat!.sendMessage(content.first);

    if (response.text != null && response.text!.isNotEmpty) {
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

  Future<String> sendMessageAssistant(
    String message,
    List<ByteData>? imageBytes,
  ) async {
    _assistantChat ??= _model.startChat();
    List<Content> content = [Content.text(message)];

    if (imageBytes != null && imageBytes.isNotEmpty) {
      List<DataPart> dataParts = imageBytes.map((byteData) {
        return DataPart('image/jpeg', byteData.buffer.asUint8List());
      }).toList();
      content = [
        Content.multi([TextPart(message), ...dataParts]),
      ];
    }

    final response = await _assistantChat!.sendMessage(content.first);

    if (response.text != null && response.text!.isNotEmpty) {
      return response.text.toString();
    } else {
      throw Exception('Error al enviar el mensaje.');
    }
  }

  @override
  @Deprecated('Use sendMessageAssistant instead')
  Future<String> sendMessageAssitant(
    String message,
    List<ByteData>? imageBytes,
  ) => sendMessageAssistant(message, imageBytes);
}
