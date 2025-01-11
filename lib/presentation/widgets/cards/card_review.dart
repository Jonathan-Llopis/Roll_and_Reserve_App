import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:roll_and_reserve/domain/entities/review_entity.dart';
import 'package:roll_and_reserve/presentation/functions/functions_utils.dart';

class CardReview extends StatelessWidget {
  const CardReview({
    super.key,
    required this.review,
  });

  final ReviewEntity review;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: ClipOval(
          child: Image(
            width: 60,
            height: 60,
            fit: BoxFit.cover,
            image: kIsWeb
                ? MemoryImage(review.avatarWriter!)
                : FileImage(File(review.avatarWriter!.path)) as ImageProvider,
            errorBuilder: (context, error, stackTrace) {
              return Icon(Icons.error, color: Colors.red);
            },
          ),
        ),
        title: Text(review.userNameWriter),
        subtitle: Column(
          children: [
            buildStars(review.raiting.toDouble()),
            Text(review.review),
          ],
        ),
      ),
    );
  }
}
