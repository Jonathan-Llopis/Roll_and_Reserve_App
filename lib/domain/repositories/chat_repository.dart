import 'package:flutter/material.dart';

abstract class ChatRepository {
  Future<String> startChat(BuildContext context,String message);
  Future<String> sendMessage(String message);
}