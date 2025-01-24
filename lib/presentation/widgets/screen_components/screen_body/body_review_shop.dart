import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:roll_and_reserve/domain/entities/review_entity.dart';
import 'package:roll_and_reserve/presentation/blocs/login/login_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/login/login_state.dart';
import 'package:roll_and_reserve/presentation/blocs/shops/shop_bloc.dart';
import 'package:roll_and_reserve/presentation/widgets/cards/card_review.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BodyReviewShop extends StatelessWidget {
  const BodyReviewShop({
    super.key,
    required this.shopBloc,
    required this.idShop,
    required this.reviews,
  });

  final ShopBloc shopBloc;
  final int idShop;
  final List<ReviewEntity> reviews;

  @override
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
                    AppLocalizations.of(context)!.shop_name(shopBloc
                        .state.shops!
                        .firstWhere((shop) => shop.id == idShop)
                        .name),
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    AppLocalizations.of(context)!.shop_reviews,
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
