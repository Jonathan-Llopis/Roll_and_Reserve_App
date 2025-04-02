import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:roll_and_reserve/domain/entities/user_entity.dart';
import 'package:roll_and_reserve/presentation/blocs/login/login_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:roll_and_reserve/presentation/widgets/cards/card_user.dart';

late List<UserEntity> users;

class BodyUsersAdmin extends StatefulWidget {
  const BodyUsersAdmin({
    super.key,
  });

  @override
  State<BodyUsersAdmin> createState() => _BodyUsersAdminState();
}

class _BodyUsersAdminState extends State<BodyUsersAdmin> {
  @override
  /// Called when the widget is inserted into the tree.
  ///
  /// This function uses the BuildContext to get the LoginBloc and set the
  /// list of users to the users of the LoginBloc. If the users are null,
  /// it sets the list to an empty list.
  void initState() {
    LoginBloc loginBloc = BlocProvider.of<LoginBloc>(context);
    if (loginBloc.state.users != null) {
      users = loginBloc.state.users!;
    } else {
      users == [];
    }
    super.initState();
  }

  @override
  /// Builds the body of the screen that shows the users.
  ///
  /// This is a [Flexible] with a [Column] with the given [children].
  ///
  /// The first child is a [Padding] with a [TextField] that filters the users
  /// by name.
  ///
  /// The second child is a [Divider] with a height of 1 and a thickness of
  /// 1.
  ///
  /// The third child is an [Expanded] with a [Padding] and a [ListView].
  /// The [ListView] has a [itemCount] equal to the length of the [users]
  /// list, and an [itemBuilder] that returns a [CardUser] with the user.
  Widget build(BuildContext context) {
    LoginBloc loginBloc = BlocProvider.of<LoginBloc>(context);
    return Flexible(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
        Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: TextField(
            onChanged: (value) {
              setState(() {
                users = loginBloc.state.users!
                    .where((user) =>
                        user.name.toLowerCase().contains(value.toLowerCase()))
                    .toList();
              });
            },
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context)!.username,
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          ),
        ),
        const Divider(height: 1, thickness: 1),
        Expanded(
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: ListView.builder(
                itemCount: users.isNotEmpty
                    ? users.length
                    : loginBloc.state.users!.length,
                itemBuilder: (context, index) {
                  final user = users.isNotEmpty
                      ? users[index]
                      : loginBloc.state.users![index];
                  return CardUser(user: user);
                },
              )),
      )],
      ),
    );
  }
}

