import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/login/login_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/reviews/reviews_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/reviews/reviews_event.dart';
import 'package:roll_and_reserve/presentation/blocs/reviews/reviews_state.dart';
import 'package:roll_and_reserve/presentation/blocs/shops/shop_bloc.dart';
import 'package:roll_and_reserve/presentation/functions/functions_show_dialogs.dart';
import 'package:roll_and_reserve/presentation/functions/state_check.dart';
import 'package:roll_and_reserve/presentation/widgets/screen_components/default_scaffold.dart';
import 'package:roll_and_reserve/presentation/widgets/screen_components/screen_body/body_review_shop.dart';

class ScreenReviewShop extends StatefulWidget {
  final int idShop;

  final PreferredSizeWidget appBar;
  const ScreenReviewShop(
      {super.key, required this.idShop, required this.appBar});

  @override
  State<ScreenReviewShop> createState() => _ScreenReviewShopState();
}

class _ScreenReviewShopState extends State<ScreenReviewShop> {
  @override
  /// Get reviews of the shop when the widget is initialized.
  ///
  /// Sends [GetReviewByShopEvent] to [ReviewBloc] to get reviews of the shop.
  void initState() {
    super.initState();
    ReviewBloc reviewBloc = BlocProvider.of<ReviewBloc>(context);
    reviewBloc.add(GetReviewByShopEvent(idShop: widget.idShop));
  }

  @override
  /// Builds the screen with the reviews of the shop.
  ///
  /// This screen is the default scaffold with the given [appBar] and a
  /// [BlocBuilder] that shows a [BodyReviewShop] if the [ReviewState] has
  /// data, an error message if there is an error, and a
  /// [CircularProgressIndicator] if the state is loading.
  ///
  /// The [BodyReviewShop] is given the [ShopBloc], the id of the shop,
  /// and the list of reviews.
  ///
  /// If the user is an administrator, the floating action button is hidden.
  /// Otherwise, the floating action button is a [FloatingActionButton] that
  /// leads to the review creation screen if the user has already written a
  /// review for the shop, and a [Container] otherwise.
  Widget build(BuildContext context) {
    ReviewBloc reviewBloc = BlocProvider.of<ReviewBloc>(context);
    LoginBloc loginBloc = BlocProvider.of<LoginBloc>(context);
    ShopBloc shopBloc = BlocProvider.of<ShopBloc>(context);

    return DefaultScaffold(
        appBar: widget.appBar,
        body: BlocBuilder<ReviewBloc, ReviewState>(
          builder: (context, state) {
            return buildContent<ReviewState>(
              state: state,
              isLoading: (state) => state.isLoading,
              errorMessage: (state) => state.errorMessage,
              hasData: (state) => state.reviews != null,
              context: context,
              contentBuilder: (state) {
                return BodyReviewShop(
                    shopBloc: shopBloc,
                    idShop: widget.idShop,
                    reviews: state.reviews!);
              },
            );
          },
        ),
        floatingActionButton: loginBloc.state.user!.role == 1
            ? Container()
            :  BlocBuilder<ReviewBloc, ReviewState>(
          builder: (context, state) {
            return buildContent<ReviewState>(
              state: state,
              isLoading: (state) => state.isLoading,
              errorMessage: (state) => state.errorMessage,
              hasData: (state) => state.reviews != null,
              context: context,
              contentBuilder: (state) {
                return  state.reviews!.any(
                    (review) => review.writerId == loginBloc.state.user!.id)
                ? Container()
                : FloatingActionButton(
                    child: const Icon(Icons.add),
                    onPressed: () {
                      createReview(
                          context, reviewBloc, widget.idShop, null);
                    },
                  );
              },
            );
          },
        ));
  }
}