class ReviewEntity {
  final int id;
  final int raiting;
  final String review;
  final String writerId;
  final String reviewedId;
  final int shopReview;
  final String userNameWriter;
  final String avatarIdWriter;
  final dynamic avatarWriter;

  ReviewEntity({
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
}
