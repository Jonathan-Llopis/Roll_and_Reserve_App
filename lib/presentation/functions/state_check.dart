import 'package:flutter/material.dart';

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
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => context.widget),
            );
          },
          child: const Text('Recargar página'),
        ),
      ],
    ));
  }

  if (hasData(state)) {
    return contentBuilder(state);
  }

  return const Center();
}
