import 'package:equatable/equatable.dart';

class ReviewEntity extends Equatable {
  final int id;
  final int raiting;
  int get rating => raiting;
  final String review;
  final String writerId;
  final String reviewedId;
  final int shopReview;
  final String userNameWriter;
  final String avatarIdWriter;
  final dynamic avatarWriter;

  const ReviewEntity({
    required this.id,
    required this.raiting,
    required this.review,
    required this.writerId,
    required this.reviewedId,
    required this.shopReview,
    required this.userNameWriter,
    required this.avatarIdWriter,
    required this.avatarWriter,
  });

  ReviewEntity copyWith({
    int? id,
    int? raiting,
    String? review,
    String? writerId,
    String? reviewedId,
    int? shopReview,
    String? userNameWriter,
    String? avatarIdWriter,
    dynamic avatarWriter,
  }) {
    return ReviewEntity(
      id: id ?? this.id,
      raiting: raiting ?? this.raiting,
      review: review ?? this.review,
      writerId: writerId ?? this.writerId,
      reviewedId: reviewedId ?? this.reviewedId,
      shopReview: shopReview ?? this.shopReview,
      userNameWriter: userNameWriter ?? this.userNameWriter,
      avatarIdWriter: avatarIdWriter ?? this.avatarIdWriter,
      avatarWriter: avatarWriter ?? this.avatarWriter,
    );
  }

  @override
  List<Object?> get props => [
        id,
        raiting,
        review,
        writerId,
        reviewedId,
        shopReview,
        userNameWriter,
        avatarIdWriter,
        avatarWriter,
      ];
}
