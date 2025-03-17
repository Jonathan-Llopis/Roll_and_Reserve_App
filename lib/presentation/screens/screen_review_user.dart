import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/login/login_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/reviews/reviews_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/reviews/reviews_event.dart';
import 'package:roll_and_reserve/presentation/blocs/reviews/reviews_state.dart';
import 'package:roll_and_reserve/presentation/functions/state_check.dart';
import 'package:roll_and_reserve/presentation/widgets/screen_components/default_scaffold.dart';
import 'package:roll_and_reserve/presentation/widgets/screen_components/screen_body/body_review_user.dart';

class ScreenReviewUser extends StatefulWidget {
  final PreferredSizeWidget appBar;
  const ScreenReviewUser({super.key, required this.appBar});

  @override
  State<ScreenReviewUser> createState() => _ScreenReviewUserState();
}

class _ScreenReviewUserState extends State<ScreenReviewUser> {
  @override
  void initState() {
    super.initState();
    LoginBloc loginBloc = BlocProvider.of<LoginBloc>(context);
    ReviewBloc reviewBloc = BlocProvider.of<ReviewBloc>(context);
    reviewBloc.add(GetReviewByUserEvent(idUser: loginBloc.state.user!.id));
  }

  @override
  Widget build(BuildContext context) {
    LoginBloc loginBloc = BlocProvider.of<LoginBloc>(context);
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
              return BodyReviewUser(
                  idUser: loginBloc.state.user!.id, reviews: state.reviews!);
            },
          );
        },
      ),
    );
  }
}
