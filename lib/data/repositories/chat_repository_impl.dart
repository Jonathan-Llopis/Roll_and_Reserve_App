import 'package:flutter/material.dart';
import 'package:roll_and_reserve/core/rol_prompt/prompt.dart';
import 'package:roll_and_reserve/data/datasources/chat_datasource.dart';
import 'package:roll_and_reserve/domain/repositories/chat_repository.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource remoteDataSource;
  

  ChatRepositoryImpl(this.remoteDataSource);

  @override
  Future<String> startChat(BuildContext context, String message) async {
    try {
      return await remoteDataSource.startChat(message);
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

  @override
  Future<String> startRolPlay(BuildContext context, String character) async {
    try {
      String prompt = getLocalizedPrompt(context, character);
      return await remoteDataSource.startRolPlay(prompt);
    } catch (e) {
      throw Exception('Error starting rol play: $e');
    }
  }

  @override
  Future<String> sendRolPlay(String message) async {
    try {
      return await remoteDataSource.sendRolPlay(message);
    } catch (e) {
      throw Exception('Error sending rol play: $e');
    }
  }
}
