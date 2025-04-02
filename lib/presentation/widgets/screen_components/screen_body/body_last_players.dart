import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:roll_and_reserve/domain/entities/user_entity.dart';
import 'package:roll_and_reserve/presentation/blocs/login/login_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/login/login_state.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:roll_and_reserve/presentation/widgets/cards/card_user.dart';

class BodyLastPlayers extends StatelessWidget {
  const BodyLastPlayers({
    super.key,
    required this.idUser,
    required this.users,
  });

  final String idUser;
  final List<UserEntity> users;

  @override
  /// Builds the body of the screen that shows the last 10 players.
  ///
  /// This is a [Column] with the given [children].
  ///
  /// The first child is a [Padding] with a [Row] with a [Column] and an
  /// [Icon]. The [Column] has a [Text] with the title "Played with" and
  /// another [Text] with an empty string. The [Icon] is a star with a size
  /// of 48 and a color of green.
  ///
  /// The second child is a [Divider] with a height of 1 and a thickness of
  /// 1.
  ///
  /// The third child is an [Expanded] with a [Padding] and a [ListView].
  /// The [ListView] has a [itemCount] equal to the length of the [users]
  /// list, and an [itemBuilder] that returns a [BlocBuilder] with the
  /// [LoginBloc] and the [LoginState]. The [BlocBuilder] returns a
  /// [CardUser] with the user and the [isLastPlayers] set to true.
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!.played_with,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                  const SizedBox(height: 4),
                  Text(
                 '',
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
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return BlocBuilder<LoginBloc, LoginState>(
                  builder: (context, state) {
                    return CardUser( user: user, isLastPlayers: true);
                  },
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
