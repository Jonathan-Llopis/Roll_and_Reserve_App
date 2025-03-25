import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Widget buildContent<T>({
  required T state,
  required bool Function(T) isLoading,
  required String? Function(T) errorMessage,
  required bool Function(T) hasData,
  required Widget Function(T) contentBuilder,
  required BuildContext context,
}) {
  if (isLoading(state)) {
    return const Center(child: CircularProgressIndicator());
  }

  final error = errorMessage(state);
  if (error != null) {
    return Center(
        child: Column(
      children: [
        Text(error),
        ElevatedButton(
            onPressed: () {
              context.go('/user');
            },
          child:  Text(AppLocalizations.of(context)!.go_to_home),
        ),
      ],
    ));
  }

  if (hasData(state)) {
    return contentBuilder(state);
  }

  return const Center();
}
