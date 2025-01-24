import 'package:flutter/material.dart';

Widget buildContent<T>({
  required T state,
  required bool Function(T) isLoading,
  required String? Function(T) errorMessage,
  required bool Function(T) hasData,
  required Widget Function(T) contentBuilder,
}) {
  if (isLoading(state)) {
    return const Center(child: CircularProgressIndicator());
  }

  final error = errorMessage(state);
  if (error != null) {
    return Center(child: Text(error));
  }

  if (hasData(state)) {
    return contentBuilder(state);
  }

  return const Center(child: Text("No hay datos disponibles"));
}