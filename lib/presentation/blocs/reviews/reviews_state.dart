import 'package:roll_and_reserve/domain/entities/review_entity.dart';

class ReviewState {
  final bool isLoading;
  final int? idReview;
  final String? errorMessage;
  final List<ReviewEntity>? reviews;
  final ReviewEntity? review;

  const ReviewState(
      {this.isLoading = false,
      this.idReview,  
      this.errorMessage,
      this.reviews,
      this.review
      });

  ReviewState copyWith({
    bool? isLoading,
    int? idReview,
    String? errorMessage,
    List<ReviewEntity>? reviews,
    ReviewEntity? review
  }) {
    return ReviewState(
        isLoading: isLoading ?? this.isLoading,
        idReview: idReview ?? this.idReview,
        errorMessage: errorMessage,
        reviews: reviews ?? this.reviews,
        review: review ?? this.review
        );
  }

    factory ReviewState.initial() => const ReviewState();

    factory ReviewState.loading() => const ReviewState(isLoading: true, errorMessage: null);

    factory ReviewState.success() => const ReviewState(errorMessage: null);

    factory ReviewState.getReview(List<ReviewEntity> reviews) => ReviewState(reviews: reviews, errorMessage: null);

    factory ReviewState.selectedReview(ReviewEntity reviewSelected) => ReviewState(review: reviewSelected, errorMessage: null);

    factory ReviewState.failure(String errorMessage) =>
        ReviewState(errorMessage: errorMessage);

}
