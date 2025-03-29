import 'package:flutter/material.dart';

abstract class ChatRepository {
  Future<String> startChat(BuildContext context,String message);
  Future<String> sendMessage(String message);
  Future<String> startRolPlay(BuildContext context, String character);
  Future<String> sendRolPlay(String message);
}