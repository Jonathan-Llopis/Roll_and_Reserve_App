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
  const ScreenReviewShop({super.key, required this.idShop});

  @override
  State<ScreenReviewShop> createState() => _ScreenReviewShopState();
}

class _ScreenReviewShopState extends State<ScreenReviewShop> {
  @override
  void initState() {
    super.initState();
    ReviewBloc reviewBloc = BlocProvider.of<ReviewBloc>(context);
    reviewBloc.add(GetReviewByShopEvent(idShop: widget.idShop));
  }

  @override
  Widget build(BuildContext context) {
    ReviewBloc reviewBloc = BlocProvider.of<ReviewBloc>(context);
    LoginBloc loginBloc = BlocProvider.of<LoginBloc>(context);
    ShopBloc shopBloc = BlocProvider.of<ShopBloc>(context);
    return BlocBuilder<ReviewBloc, ReviewState>(
      builder: (context, state) {
        return buildContent<ReviewState>(
            state: state,
            isLoading: (state) => state.isLoading,
            errorMessage: (state) => state.errorMessage,
            hasData: (state) => state.reviews != null,
            contentBuilder: (state) {
              return DefaultScaffold(
                  body: BodyReviewShop(
                      shopBloc: shopBloc,
                      idShop: widget.idShop,
                      reviews: state.reviews!),
                  floatingActionButton: loginBloc.state.user!.role == 1
                      ? Container()
                      : state.reviews!.any((review) =>
                              review.writerId == loginBloc.state.user!.id)
                          ? Container()
                          : FloatingActionButton(
                              backgroundColor: Colors.deepPurple,
                              child: const Icon(Icons.add),
                              onPressed: () {
                                createReview(context, reviewBloc, shopBloc,
                                    widget.idShop);
                              },
                            ));
            });
      },
    );
  }
}
