import 'package:roll_and_reserve/domain/entities/review_entity.dart';

class ReviewModel {
  final int id;
  final int raiting;
  final String review;
  final String writerId;
  final String userNameWriter;
  final String avatarIdWriter;
  final dynamic avatarWriter;
  final String reviewedId;
  final int shopReview;

  ReviewModel(
      {required this.id,
      required this.raiting,
      required this.review,
      required this.writerId,
      required this.reviewedId,
      required this.shopReview,
      required this.userNameWriter,
      required this.avatarIdWriter,
      required this.avatarWriter});

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
        id: json['id_review'],
        raiting: json['raiting'],
        review: json['review'],
        writerId: json['writer']['id_google'] ?? "",
        reviewedId:
            json['reviewed'] == null ? "" : json['reviewed']['id_google'] ?? "",
        shopReview:
            json['shop_reviews'] == null ? 0 : json['shop_reviews']['id_shop'],
        userNameWriter: json['writer']['username'] ?? "",
        avatarIdWriter: json['writer']['avatar'] ?? "",
        avatarWriter:[]);
  }

  Map<String, dynamic> shopReviewToJson() => {
        'id_review': id,
        'raiting': raiting,
        'review': review,
        'writer': writerId,
        'shop_reviews': shopReview
      };

  ReviewEntity toReviewEntity(dynamic avatarFile) {
    return ReviewEntity(
        id: id,
        raiting: raiting,
        review: review,
        writerId: writerId,
        reviewedId: reviewedId,
        shopReview: shopReview,
        avatarWriter: avatarFile,
        avatarIdWriter: avatarIdWriter,
        userNameWriter: userNameWriter);
  }
}
