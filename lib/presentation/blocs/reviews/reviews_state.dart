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
      this.review});

  ReviewState copyWith(
      {bool? isLoading,
      int? idReview,
      String? errorMessage,
      List<ReviewEntity>? reviews,
      ReviewEntity? review}) {
    return ReviewState(
        isLoading: isLoading ?? this.isLoading,
        idReview: idReview ?? this.idReview,
        errorMessage: errorMessage,
        reviews: reviews ?? this.reviews,
        review: review ?? this.review);
  }

  factory ReviewState.initial(ReviewState state) => state.copyWith();

  factory ReviewState.loading(ReviewState state) =>
      state.copyWith(isLoading: true,errorMessage: null);

  factory ReviewState.success(ReviewState state) =>
      state.copyWith(isLoading: false, errorMessage: null);

  factory ReviewState.getReview(
          ReviewState state, List<ReviewEntity> reviews) =>
      state.copyWith(reviews: reviews, isLoading: false, errorMessage: null);

  factory ReviewState.selectedReview(
          ReviewState state, ReviewEntity reviewSelected) =>
      state.copyWith(
          review: reviewSelected, isLoading: false, errorMessage: null);

  factory ReviewState.failure(ReviewState state, String errorMessage) =>
      state.copyWith(errorMessage: errorMessage, isLoading: false);
}
