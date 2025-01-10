import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:roll_and_reserve/presentation/blocs/login/login_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/reviews/reviews_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/reviews/reviews_event.dart';
import 'package:roll_and_reserve/presentation/blocs/reviews/reviews_state.dart';
import 'package:roll_and_reserve/presentation/functions/functions_show_dialogs.dart';
import 'package:roll_and_reserve/presentation/widgets/cards/card_review.dart';

class StoreReviewsPage extends StatefulWidget {
  final int idShop;
  const StoreReviewsPage({super.key, required this.idShop});

  @override
  State<StoreReviewsPage> createState() => _StoreReviewsPageState();
}

class _StoreReviewsPageState extends State<StoreReviewsPage> {
  @override
  void initState() {
    context.read<ReviewBloc>().add(GetReviewByShopEvent(idShop: widget.idShop));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    LoginBloc loginBloc = BlocProvider.of<LoginBloc>(context);
    return BlocBuilder<ReviewBloc, ReviewState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state.errorMessage != null) {
          return Center(child: Text(state.errorMessage!));
        } else if (state.reviews != null) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Reseñas de la Tienda'),
              backgroundColor: Colors.deepPurple,
              leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    context.go('/user/shop/${widget.idShop}');
                  }),
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView.builder(
                itemCount: state.reviews!.length,
                itemBuilder: (context, index) {
                  final review = state.reviews![index];
                  return BuildReviewCard(review: review);
                },
              ),
            ),
            floatingActionButton: loginBloc.state.user!.role == 1
                ? Container()
                : FloatingActionButton(
                    backgroundColor: Colors.deepPurple,
                    child: const Icon(Icons.add),
                    onPressed: () {
                      createReview(context, widget.idShop);
                    },
                  ),
          );
        }
        return Container();
      },
    );
  }
}
