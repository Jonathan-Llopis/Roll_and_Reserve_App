import 'package:equatable/equatable.dart';
import 'package:roll_and_reserve/domain/entities/review_entity.dart';

sealed class ReviewState extends Equatable {
  final int? idReview;
  final List<ReviewEntity>? reviews;
  final ReviewEntity? review;

  const ReviewState({
    this.idReview,
    this.reviews,
    this.review,
  });

  bool get isLoading => this is ReviewLoading;
  String? get errorMessage =>
      this is ReviewFailure ? (this as ReviewFailure).message : null;

  @override
  List<Object?> get props => [
        idReview,
        reviews,
        review,
      ];
}

class ReviewInitial extends ReviewState {
  const ReviewInitial() : super();
}

class ReviewLoading extends ReviewState {
  const ReviewLoading({
    super.idReview,
    super.reviews,
    super.review,
  });
}

class ReviewSuccess extends ReviewState {
  const ReviewSuccess({
    super.idReview,
    super.reviews,
    super.review,
  });
}

class ReviewFailure extends ReviewState {
  final String message;
  const ReviewFailure(
    this.message, {
    super.idReview,
    super.reviews,
    super.review,
  });

  @override
  List<Object?> get props => [super.props, message];
}
