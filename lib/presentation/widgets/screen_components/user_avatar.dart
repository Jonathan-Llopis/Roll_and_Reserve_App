
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
  /// Builds a [CircleAvatar] with the user's avatar or a default image.
  ///
  /// If the user's avatar is not null, it is displayed in a [ClipOval] to make
  /// it a circle. If the user's avatar is null, a default image is displayed.
  ///
  /// The image is displayed in a [CircleAvatar] with a radius of 28 and a
  /// background color of [Colors.grey.shade200].
  ///
  /// If the image fails to load, an [Icon] is displayed with the person outline
  /// icon and a size of 28.
  ///
  /// If the image is loading, a [CircularProgressIndicator] is displayed with
  /// the value of the progress.
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
