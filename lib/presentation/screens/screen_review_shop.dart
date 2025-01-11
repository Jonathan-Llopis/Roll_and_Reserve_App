import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/login/login_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/login/login_state.dart';
import 'package:roll_and_reserve/presentation/blocs/reviews/reviews_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/reviews/reviews_event.dart';
import 'package:roll_and_reserve/presentation/blocs/reviews/reviews_state.dart';
import 'package:roll_and_reserve/presentation/blocs/shops/shop_bloc.dart';
import 'package:roll_and_reserve/presentation/functions/functions_show_dialogs.dart';
import 'package:roll_and_reserve/presentation/widgets/cards/card_review.dart';
import 'package:roll_and_reserve/presentation/widgets/screen_components/default_app_bar.dart';
import 'package:roll_and_reserve/presentation/widgets/screen_components/drawer_main.dart';

class ScreenReviewShop extends StatelessWidget {
  final int idShop;
  const ScreenReviewShop({super.key, required this.idShop});

  @override
  Widget build(BuildContext context) {
    context.read<ReviewBloc>().add(GetReviewByShopEvent(idShop: idShop));
    var scaffoldKey = GlobalKey<ScaffoldState>();
    LoginBloc loginBloc = BlocProvider.of<LoginBloc>(context);
    ShopBloc shopBloc = BlocProvider.of<ShopBloc>(context);
    return BlocBuilder<ReviewBloc, ReviewState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state.errorMessage != null) {
          return Center(child: Text(state.errorMessage!));
        } else if (state.reviews != null) {
          return Scaffold(
            key: scaffoldKey,
            appBar: DefaultAppBar(scaffoldKey: scaffoldKey, ),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            " Tienda ${shopBloc.state.shops!.firstWhere((shop) => shop.id == idShop).name}",
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            "Reviews de la tienda.",
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                        ],
                      ),
                      const Icon(Icons.star, size: 48, color: Colors.green),
                    ],
                  ),
                ),
                const Divider(height: 1, thickness: 1),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: ListView.builder(
                      itemCount: state.reviews!.length,
                      itemBuilder: (context, index) {
                        final review = state.reviews![index];
                        return BlocBuilder<LoginBloc, LoginState>(
                          builder: (context, state) {
                            return CardReview(review: review);
                          },
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
            endDrawer: DrawerMain(),
            floatingActionButton: loginBloc.state.user!.role == 1
                ? Container()
                : state.reviews!.any(
                        (review) => review.writerId == loginBloc.state.user!.id)
                    ? Container()
                    : FloatingActionButton(
                        backgroundColor: Colors.deepPurple,
                        child: const Icon(Icons.add),
                        onPressed: () {
                          createReview(context, idShop);
                        },
                      ),
          );
        }
        return Container();
      },
    );
  }
}
