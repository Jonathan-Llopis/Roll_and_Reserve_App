import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// Builds a widget based on the given state.
///
/// If the state is loading, shows a [CircularProgressIndicator].
/// If the state has an error, shows an error message with a button to go to
/// the home page.
/// If the state has data, calls the [contentBuilder] to build a widget.
/// Otherwise, shows an empty [Center].
///
/// The [isLoading], [errorMessage], and [hasData] functions are used to
/// determine the state of the widget. The [contentBuilder] is used to build
/// the widget if the state has data.
///
/// The [context] is used to navigate to the home page if the state has an error.
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
