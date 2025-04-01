import 'dart:typed_data';

import 'package:flutter/material.dart';

abstract class ChatRepository {
  Future<String> startChat(BuildContext context,String message);
  Future<String> sendMessage(String message);
  Future<String> startRolPlay(BuildContext context, String character, String theme);
  Future<String> sendRolPlay(String message);
  Future<String> startChatGemini(BuildContext context);
  Future<String> sendMessageGemini(String message, {List<ByteData>? imageBytes});
  Future<String> startChatAssistant(BuildContext context);
  Future<String> sendMessageAssitant(String message, {List<ByteData>? imageBytes});
}