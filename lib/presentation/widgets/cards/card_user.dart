import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:roll_and_reserve/domain/entities/user_entity.dart';
import 'package:roll_and_reserve/presentation/functions/functions_utils.dart';


class CardUser extends StatelessWidget {
  final UserEntity user;
  const CardUser({
    super.key,
    required this.user,
  });
  @override
  Widget build(BuildContext context) {
    return Card(
      color: user.reserveConfirmation! ?Colors.green  :  Colors.red, 
      margin: EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: ClipOval(
          child: Image(
            width: 60,
            height: 60,
            fit: BoxFit.cover,
            image: kIsWeb
                ? MemoryImage(user.avatar)
                : FileImage(File(user.avatar.path)) as ImageProvider,
            errorBuilder: (context, error, stackTrace) {
              return Icon(Icons.error, color: Colors.red);
            },
          ),
        ),
        title: Text(user.name),
        subtitle: buildStars(user.averageRaiting),
      ),
    );
  }
}
