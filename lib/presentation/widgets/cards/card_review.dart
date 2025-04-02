import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:roll_and_reserve/domain/entities/review_entity.dart';
import 'package:roll_and_reserve/presentation/functions/functions_utils.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CardReview extends StatelessWidget {
  const CardReview({
    super.key,
    required this.review,
  });

  final ReviewEntity review;

  @override
/// Builds a review card widget.
///
/// This widget displays a review with the following components:
/// - An avatar image of the review writer, displayed as a circular image.
/// - The name of the review writer. If the name is empty, it displays "anonymous".
/// - The review rating represented by stars.
/// - The review text content.
///
/// The card has a bottom margin and handles image loading errors by displaying an error icon.

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
        title: Text(review.userNameWriter == "" ?  AppLocalizations.of(context)!.anonymous : review.userNameWriter),
        subtitle: Column(
          children: [
            buildStars(review.raiting.toDouble(),),
            Text(review.review),
          ],
        ),
      ),
    );
  }
}
