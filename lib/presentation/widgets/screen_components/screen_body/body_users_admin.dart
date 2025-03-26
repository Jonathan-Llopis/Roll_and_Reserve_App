import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/login/login_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:roll_and_reserve/presentation/widgets/cards/card_user.dart';

class BodyUsersAdmin extends StatelessWidget {
  const BodyUsersAdmin({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    LoginBloc loginBloc = BlocProvider.of<LoginBloc>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Text(
            AppLocalizations.of(context)!.all_users,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold, color: Colors.black87),
          ),
        ),
        const Divider(height: 1, thickness: 1),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: ListView.builder(
              itemCount: loginBloc.state.users!.length,
              itemBuilder: (context, index) {
                final user = loginBloc.state.users![index];
                return CardUser(user:   user);
              },
            ),
          ),
        )],
    );
  }
}