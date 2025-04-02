import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:roll_and_reserve/domain/entities/review_entity.dart';
import 'package:roll_and_reserve/presentation/blocs/login/login_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/login/login_state.dart';
import 'package:roll_and_reserve/presentation/widgets/cards/card_review.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BodyReviewUser extends StatelessWidget {
  const BodyReviewUser({
    super.key,
    required this.idUser,
    required this.reviews,
  });

  final String idUser;
  final List<ReviewEntity> reviews;

  @override
  /// Builds the body of the screen that shows the reviews of the user.
  ///
  /// This is a [Column] with the title, a [Divider], and a [ListView] with
  /// the reviews.
  ///
  /// The [ListView] is scrollable and is given by the [reviews] list.
  ///
  /// Each review is shown as a [CardReview] with the review.
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                   "Reviews",
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    AppLocalizations.of(context)!.received_reviews,
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
              const Icon(Icons.star, size: 48, color: Colors.green),
            ],
          ),
        ),
        const Divider(height: 1, thickness: 1),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: ListView.builder(
              itemCount: reviews.length,
              itemBuilder: (context, index) {
                final review = reviews[index];
                return BlocBuilder<LoginBloc, LoginState>(
                  builder: (context, state) {
                    return CardReview(review: review);
                  },
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
