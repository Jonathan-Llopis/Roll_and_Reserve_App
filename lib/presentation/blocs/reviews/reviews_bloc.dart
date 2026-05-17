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
  ) : super(const ReviewInitial()) {
    on<GetReviewsEvent>((event, emit) async {
      emit(
        ReviewLoading(
          idReview: state.idReview,
          reviews: state.reviews,
          review: state.review,
        ),
      );
      final result = await getReviewUseCase(NoParams());
      result.fold(
        (failure) => emit(
          ReviewFailure(
            'Fallo al realizar la recuperación',
            idReview: state.idReview,
            reviews: state.reviews,
            review: state.review,
          ),
        ),
        (reviewss) => emit(
          ReviewSuccess(
            idReview: state.idReview,
            reviews: reviewss,
            review: state.review,
          ),
        ),
      );
    });

    on<GetReviewEvent>((event, emit) async {
      emit(
        ReviewLoading(
          idReview: state.idReview,
          reviews: state.reviews,
          review: state.review,
        ),
      );
      final result = await getReviewUseCase(NoParams());
      result.fold(
        (failure) => emit(
          ReviewFailure(
            'Fallo al realizar la recuperación',
            idReview: state.idReview,
            reviews: state.reviews,
            review: state.review,
          ),
        ),
        (reviewss) {
          final reviews =
              reviewss.firstWhere((reviews) => reviews.id == event.idReview);
          emit(
            ReviewSuccess(
              idReview: state.idReview,
              reviews: reviewss,
              review: reviews,
            ),
          );
        },
      );
    });
    on<CreateReviewEvent>((event, emit) async {
      emit(
        ReviewLoading(
          idReview: state.idReview,
          reviews: state.reviews,
          review: state.review,
        ),
      );
      final result = await createReviewUseCase(event.review);
      result.fold(
        (failure) => emit(
          ReviewFailure(
            'Fallo al crear reseña',
            idReview: state.idReview,
            reviews: state.reviews,
            review: state.review,
          ),
        ),
        (_) {
          emit(
            ReviewSuccess(
              idReview: state.idReview,
              reviews: state.reviews,
              review: state.review,
            ),
          );
          add(GetReviewByShopEvent(idShop: event.review.shopReview));
        },
      );
    });
    on<DeleteReviewEvent>((event, emit) async {
      emit(
        ReviewLoading(
          idReview: state.idReview,
          reviews: state.reviews,
          review: state.review,
        ),
      );
      final result = await deleteReviewUseCase(event.idReview);
      result.fold(
        (failure) => emit(
          ReviewFailure(
            'Fallo al eliminar reseña',
            idReview: state.idReview,
            reviews: state.reviews,
            review: state.review,
          ),
        ),
        (_) {
          emit(
            ReviewSuccess(
              idReview: state.idReview,
              reviews: state.reviews,
              review: state.review,
            ),
          );
          add(GetReviewsEvent());
        },
      );
    });
    on<GetReviewByShopEvent>((event, emit) async {
      emit(
        ReviewLoading(
          idReview: state.idReview,
          reviews: state.reviews,
          review: state.review,
        ),
      );
      final result = await getReviewUseCase(NoParams());
      result.fold(
        (failure) => emit(
          ReviewFailure(
            'Fallo al realizar la recuperación',
            idReview: state.idReview,
            reviews: state.reviews,
            review: state.review,
          ),
        ),
        (reviewss) {
          final reviewssByOwner = reviewss
              .where((reviews) => reviews.shopReview == event.idShop)
              .toList();
          emit(
            ReviewSuccess(
              idReview: state.idReview,
              reviews: reviewssByOwner,
              review: state.review,
            ),
          );
        },
      );
    });
    on<GetReviewByUserEvent>((event, emit) async {
      emit(
        ReviewLoading(
          idReview: state.idReview,
          reviews: state.reviews,
          review: state.review,
        ),
      );
      final result = await getReviewUseCase(NoParams());
      result.fold(
        (failure) => emit(
          ReviewFailure(
            'Fallo al realizar la recuperación',
            idReview: state.idReview,
            reviews: state.reviews,
            review: state.review,
          ),
        ),
        (reviewss) {
          final reviewssByOwner = reviewss
              .where((reviews) => reviews.reviewedId == event.idUser)
              .toList();
          emit(
            ReviewSuccess(
              idReview: state.idReview,
              reviews: reviewssByOwner,
              review: state.review,
            ),
          );
        },
      );
    });
    on<GetReviewByWritterEvent>((event, emit) async {
      emit(
        ReviewLoading(
          idReview: state.idReview,
          reviews: state.reviews,
          review: state.review,
        ),
      );
      final result = await getReviewUseCase(NoParams());
      result.fold(
        (failure) => emit(
          ReviewFailure(
            'Fallo al realizar la recuperación',
            idReview: state.idReview,
            reviews: state.reviews,
            review: state.review,
          ),
        ),
        (reviewss) {
          final reviewssByOwner = reviewss
              .where((reviews) => reviews.writerId == event.idWritter)
              .toList();
          emit(
            ReviewSuccess(
              idReview: state.idReview,
              reviews: reviewssByOwner,
              review: state.review,
            ),
          );
        },
      );
    });
  }
}
