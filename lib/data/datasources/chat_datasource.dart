import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

abstract class ChatRemoteDataSource {
  Future<dynamic> startChat(String prompt);
  Future<dynamic> sendMessage(String message);
}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  ChatRemoteDataSourceImpl();

  final model = GenerativeModel(
    model: 'gemini-1.5-flash',
    apiKey: dotenv.env['OPENAI_API_KEY']!,
  );

  late dynamic chat;

  @override
  Future<dynamic> startChat(String prompt) async {
    chat = model.startChat();
    final content = [Content.text(prompt)];
    final response = await chat.sendMessage(content.first);

    if (response.text != '') {
      return chat;
    } else {
      throw Exception('Error al iniciar el Chat.');
    }
  }
  @override
  Future<dynamic> sendMessage(String message) async {
    final content = [Content.text(message)];
    final response = await chat.sendMessage(content.first);

    if (response.text != '') {
      return chat;
    } else {
      throw Exception('Error al enviar el mensaje.');
    }
  }
}