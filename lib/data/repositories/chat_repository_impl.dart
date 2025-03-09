import 'package:flutter/material.dart';
import 'package:roll_and_reserve/core/prompt.dart';
import 'package:roll_and_reserve/data/datasources/chat_datasource.dart';
import 'package:roll_and_reserve/domain/repositories/chat_repository.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource remoteDataSource;
  

  ChatRepositoryImpl(this.remoteDataSource);

  @override
  Future<String> startChat(BuildContext context) async {
    try {
      String prompt = getLocalizedPrompt(context);
      return await remoteDataSource.startChat(prompt);
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
}
