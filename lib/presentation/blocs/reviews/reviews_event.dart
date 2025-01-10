import 'package:equatable/equatable.dart';
import 'package:roll_and_reserve/domain/entities/review_entity.dart';

abstract class ReviewEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetReviewsEvent extends ReviewEvent {}

class GetReviewEvent extends ReviewEvent {
  final int idReview;  
  GetReviewEvent({required this.idReview});

  @override
  List<Object?> get props => [idReview];
}

class CreateReviewEvent extends ReviewEvent {
  final ReviewEntity review;
  CreateReviewEvent({required this.review});

  @override
  List<Object?> get props => [review];
}

class DeleteReviewEvent extends ReviewEvent {
  final int idReview;
  final String idOwner;
  DeleteReviewEvent({required this.idReview, required this.idOwner});

  @override
  List<Object?> get props => [idReview];
}

class GetReviewByShopEvent extends ReviewEvent {
  final int idShop;
  GetReviewByShopEvent({required this.idShop});

  @override
  List<Object?> get props => [idShop];
}
class GetReviewByUserEvent extends ReviewEvent {
  final String idUser;
  GetReviewByUserEvent({required this.idUser});

  @override
  List<Object?> get props => [idUser];
}
class GetReviewByWritterEvent extends ReviewEvent {
  final String idWritter;
  GetReviewByWritterEvent({required this.idWritter});

  @override
  List<Object?> get props => [idWritter];
}