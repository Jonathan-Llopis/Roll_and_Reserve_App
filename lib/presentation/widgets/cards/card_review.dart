import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:roll_and_reserve/domain/entities/review_entity.dart';
import 'package:roll_and_reserve/presentation/blocs/login/login_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/login/login_event.dart';
import 'package:roll_and_reserve/presentation/blocs/login/login_state.dart';
import 'package:roll_and_reserve/presentation/functions/functions_dialogs.dart';

class BuildReviewCard extends StatefulWidget {
  const BuildReviewCard({
    super.key,
    required this.review,
  });

  final ReviewEntity review;

  @override
  State<BuildReviewCard> createState() => _BuildReviewCardState();
}

class _BuildReviewCardState extends State<BuildReviewCard> {
  @override
  void initState() {
    context
        .read<LoginBloc>()
        .add(GetOtherUserInfoEvent(idGoogle: widget.review.writerId));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
      if (state.isLoading) {
        return const Center(child: CircularProgressIndicator());
      } else if (state.errorMessage != null) {
        return Center(child: Text(state.errorMessage!));
      } else if (state.findUser != null) {
        return Card(
          margin: EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: ClipOval(
              child: Image(
                width: 60,
                height: 60,
                fit: BoxFit.cover,
                image: kIsWeb
                    ? MemoryImage(state.findUser!.avatar!)
                    : FileImage(File(state.findUser!.avatar.path))
                        as ImageProvider,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(Icons.error, color: Colors.red);
                },
              ),
            ),
            title: Text(state.findUser!.name),
            subtitle: Column(
              children: [
                buildStars(widget.review.raiting.toDouble()),
                Text(widget.review.review),
              ],
            ),
          ),
        );
      }
      return Container();
    });
  }
}
