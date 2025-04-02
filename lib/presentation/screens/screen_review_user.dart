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
  /// Gets reviews of the user when the widget is initialized.
  ///
  /// Sends [GetReviewByUserEvent] to [ReviewBloc] to get reviews of the user.
  void initState() {
    super.initState();
    LoginBloc loginBloc = BlocProvider.of<LoginBloc>(context);
    ReviewBloc reviewBloc = BlocProvider.of<ReviewBloc>(context);
    reviewBloc.add(GetReviewByUserEvent(idUser: loginBloc.state.user!.id));
  }

  @override

  /// Builds the screen with the reviews of the user.
  ///
  /// This screen is the default scaffold with the given [appBar] and a
  /// [BlocBuilder] that shows a [BodyReviewUser] if the [ReviewState] has
  /// data, an error message if there is an error, and a
  /// [CircularProgressIndicator] if the state is loading.
  ///
  /// The [BodyReviewUser] is given the id of the user, and the list of reviews.
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
