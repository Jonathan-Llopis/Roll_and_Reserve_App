import 'package:roll_and_reserve/data/models/review_model.dart';

class ReviewEntity {
  final int id;
  final int raiting;
  final String review;
  final String writerId;
  final String reviewedId;
  final int shopReview;

  ReviewEntity(
      {required this.id,
      required this.raiting,
      required this.review,
      required this.writerId,
      required this.reviewedId,
      required this.shopReview});

  ReviewModel toReviewModel() {
    return ReviewModel(
        id: id,
        raiting: raiting,
        review: review,
        writerId: writerId,
        reviewedId: reviewedId,
        shopReview: shopReview);
  }
}
