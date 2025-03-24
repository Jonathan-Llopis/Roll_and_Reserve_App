import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';

Widget buildContentSkeleton<T>({
  required T state,
  required bool Function(T) isLoading,
  required String? Function(T) errorMessage,
  required bool Function(T) hasData,
  required Widget Function(T) contentBuilder,
  required BuildContext context,
}) {
  if (isLoading(state)) {
    return Skeletonizer.zone(
      child: Card(
      child: ListTile(
        leading: Bone.circle(size: 48),
        title: Bone.text(words: 2),
        subtitle: Bone.text(),
        trailing: Bone.icon(),
      ),
      ),
    );
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
