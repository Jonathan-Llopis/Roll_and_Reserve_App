import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/login/login_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/login/login_event.dart';
import 'package:roll_and_reserve/presentation/blocs/login/login_state.dart';
import 'package:roll_and_reserve/presentation/functions/functions_dialogs.dart';

class UserCardTable extends StatelessWidget {
  final String idUser;
  const UserCardTable({
    super.key,
    required this.idUser,
  });

  @override
  Widget build(BuildContext context) {
    context.read<LoginBloc>().add(GetUserInfoEvent(idGoogle: idUser));
    return BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
      if (state.isLoading) {
        return const Center(child: CircularProgressIndicator());
      } else if (state.errorMessage != null) {
        return Center(child: Text(state.errorMessage!));
      } else if (state.user != null) {
        return Card(
          margin: EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: ClipOval(
              child: Image(
                width: 60,
                height: 60,
                fit: BoxFit.cover,
                image: kIsWeb
                    ? MemoryImage(state.user!.avatar!)
                    : FileImage(File(state.user!.avatar.path)) as ImageProvider,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(Icons.error, color: Colors.red);
                },
              ),
            ),
            title: Text(state.user!.name),
            subtitle: buildStars(state.user!.averageRaiting),
          ),
        );
      }
      return Container();
    });
  }
}
