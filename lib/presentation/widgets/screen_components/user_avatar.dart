
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../domain/entities/user_entity.dart';

class UserAvatar extends StatelessWidget {
  const UserAvatar({
    super.key,
    required this.user,
  });

  final UserEntity user;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 28,
      backgroundColor: Colors.grey.shade200,
      child: ClipOval(
        child: Image(
          width: 56,
          height: 56,
          fit: BoxFit.cover,
          image: kIsWeb
              ? MemoryImage(user.avatar)
              : FileImage(File(user.avatar.path)) as ImageProvider,
          errorBuilder: (context, error, stackTrace) {
            return Icon(
              Icons.person_outline,
              size: 28,
              color: Colors.grey.shade600,
            );
          },
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes!
                  : null,
            );
          },
        ),
      ),
    );
  }
}
