import 'package:flutter/material.dart';

abstract class ChatRepository {
  Future<String> startChat(BuildContext context);
  Future<String> sendMessage(String message);
}