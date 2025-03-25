import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:roll_and_reserve/domain/entities/user_entity.dart';
import 'package:roll_and_reserve/presentation/blocs/reviews/reviews_bloc.dart';
import 'package:roll_and_reserve/presentation/functions/functions_show_dialogs.dart';
import 'package:roll_and_reserve/presentation/functions/functions_utils.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CardUser extends StatelessWidget {
  final UserEntity user;
  final bool? isLastPlayers;

  const CardUser({
    super.key,
    required this.user,
    this.isLastPlayers,
  });

  @override
  Widget build(BuildContext context) {
    final ReviewBloc reviewBloc = BlocProvider.of<ReviewBloc>(context);
    final ThemeData theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: MouseRegion(
        cursor: isLastPlayers == true
            ? SystemMouseCursors.click
            : MouseCursor.defer,
        child: GestureDetector(
          onTap: () {
            if (isLastPlayers == true) {
              createReview(context, reviewBloc, null, user.id);
            }
          },
          child: Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
              side: BorderSide(
                color: theme.dividerColor.withOpacity(0.1),
                width: 1,
              ),
            ),
            color: _getCardColor(context),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  _buildUserAvatar(),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.name,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            buildStars(user.averageRaiting),
                            const SizedBox(width: 8),
                            Text(
                              '${AppLocalizations.of(context)!.rating}: ${user.averageRaiting.toStringAsFixed(1)}',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurface
                                    .withOpacity(0.7),
                              ),
                            ),
                          ],
                        ),
                        if (user.reserveConfirmation != null &&
                            isLastPlayers == null) ...[
                          const SizedBox(height: 4),
                          _buildStatusIndicator(context),
                        ]
                      ],
                    ),
                  ),
                  if (isLastPlayers == true)
                    Icon(
                      Icons.rate_review_outlined,
                      color: theme.colorScheme.primary,
                      size: 20,
                    )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color _getCardColor(BuildContext context) {
    if (isLastPlayers == true) {
      return Theme.of(context).colorScheme.surfaceVariant;
    }
    return user.reserveConfirmation ?? false
        ? Color.fromARGB(255, 89, 240, 29).withOpacity(0.1)
        : Theme.of(context).colorScheme.errorContainer;
  }

  Widget _buildUserAvatar() {
    return CircleAvatar(
      radius: 28,
      backgroundColor: Colors.grey.shade200,
      child: ClipOval(
        child: Image(
          width: 56,
          height: 56,
          fit: BoxFit.cover,
          image: kIsWeb
              ? MemoryImage(user.avatar)
              : FileImage(File(user.avatar.path)) as ImageProvider,
          errorBuilder: (context, error, stackTrace) {
            return Icon(
              Icons.person_outline,
              size: 28,
              color: Colors.grey.shade600,
            );
          },
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes!
                  : null,
            );
          },
        ),
      ),
    );
  }

  Widget _buildStatusIndicator(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: user.reserveConfirmation!
            ? Color(0xFF00695C).withOpacity(0.1)
            : Theme.of(context).colorScheme.error.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        user.reserveConfirmation!
            ? AppLocalizations.of(context)!.confirmed
            : AppLocalizations.of(context)!.pending,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: user.reserveConfirmation!
                  ? Color(0xFF00695C)
                  : Theme.of(context).colorScheme.error,
              fontWeight: FontWeight.w500,
            ),
      ),
    );
  }
}
