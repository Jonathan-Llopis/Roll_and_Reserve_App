import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:roll_and_reserve/core/use_case.dart';
import 'package:roll_and_reserve/domain/usecases/review_usecases/create_review_usecase.dart';
import 'package:roll_and_reserve/domain/usecases/review_usecases/delete_review_usecase.dart';
import 'package:roll_and_reserve/domain/usecases/review_usecases/get_all_review_usecase.dart';
import 'package:roll_and_reserve/presentation/blocs/reviews/reviews_event.dart';
import 'package:roll_and_reserve/presentation/blocs/reviews/reviews_state.dart';


class ReviewBloc extends Bloc<ReviewEvent, ReviewState> {
  final CreateReviewUseCase createReviewUseCase;
  final GetAllReviewUseCase getReviewUseCase;
  final DeleteReviewUseCase deleteReviewUseCase;

  ReviewBloc(
    this.createReviewUseCase,
    this.getReviewUseCase,
    this.deleteReviewUseCase,
  ) : super(const ReviewState()) {
    on<GetReviewsEvent>((event, emit) async {
      emit(ReviewState.loading(state));
      final result = await getReviewUseCase(NoParams());
      result.fold(
        (failure) =>
            emit(ReviewState.failure(state, "Fallo al realizar la recuperacion")),
        (reviewss) => emit(ReviewState.getReview(state,reviewss)),
      );
    });

    on<GetReviewEvent>((event, emit) async {
      emit(ReviewState.loading(state));
      final result = await getReviewUseCase(NoParams());
      result.fold(
        (failure) =>
            emit(ReviewState.failure(state,"Fallo al realizar la recuperacion")),
        (reviewss) {
          final reviews = reviewss.firstWhere((reviews) => reviews.id == event.idReview);
          emit(ReviewState.selectedReview(state,reviews));
        },
      );
    });
    on<CreateReviewEvent>((event, emit) async {
      emit(ReviewState.loading(state));
      final result = await createReviewUseCase(event.review);
      result.fold(
        (failure) => emit(ReviewState.failure(state,"Fallo al crear tienda")),
        (_) {
          emit(
            ReviewState.success(state),
          );
          add(GetReviewByShopEvent(idShop: event.review.shopReview));
        },
      );
    });
    on<DeleteReviewEvent>((event, emit) async {
      emit(ReviewState.loading(state));
      final result = await deleteReviewUseCase(event.idReview);
      result.fold(
        (failure) => emit(ReviewState.failure(state,"Fallo al eliminar tienda")),
        (_) {
          emit(
            ReviewState.success(state),
          );
          add(GetReviewsEvent());
        },
      );
    });
    on<GetReviewByShopEvent>((event, emit) async {
      emit(ReviewState.loading(state));
      final result = await getReviewUseCase(NoParams());
      result.fold(
        (failure) =>
            emit(ReviewState.failure(state,"Fallo al realizar la recuperacion")),
        (reviewss) {
          final reviewssByOwner =
              reviewss.where((reviews) => reviews.shopReview == event.idShop).toList();
          emit(ReviewState.getReview(state,reviewssByOwner));
        },
      );
    });
    on<GetReviewByUserEvent>((event, emit) async {
      emit(ReviewState.loading(state));
      final result = await getReviewUseCase(NoParams());
      result.fold(
        (failure) =>
            emit(ReviewState.failure(state,"Fallo al realizar la recuperacion")),
        (reviewss) {
          final reviewssByOwner =
              reviewss.where((reviews) => reviews.reviewedId == event.idUser).toList();
          emit(ReviewState.getReview(state,reviewssByOwner));
        },
      );
    });
    on<GetReviewByWritterEvent>((event, emit) async {
      emit(ReviewState.loading(state));
      final result = await getReviewUseCase(NoParams());
      result.fold(
        (failure) =>
            emit(ReviewState.failure(state,"Fallo al realizar la recuperacion")),
        (reviewss) {
          final reviewssByOwner =
              reviewss.where((reviews) => reviews.writerId == event.idWritter).toList();
          emit(ReviewState.getReview(state,reviewssByOwner));
        },
      );
    });
  }
}
