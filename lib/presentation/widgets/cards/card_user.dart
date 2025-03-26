import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:roll_and_reserve/domain/entities/user_entity.dart';
import 'package:roll_and_reserve/presentation/blocs/login/login_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/reviews/reviews_bloc.dart';
import 'package:roll_and_reserve/presentation/functions/functions_show_dialogs.dart';
import 'package:roll_and_reserve/presentation/functions/functions_utils.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:roll_and_reserve/presentation/widgets/screen_components/user_avatar.dart';

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
    final LoginBloc loginBloc = BlocProvider.of<LoginBloc>(context);

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
            color: loginBloc.state.user!.role == 0
                ? _getRoleColor(context)
                : _getCardColor(context),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  UserAvatar(user: user),
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
                          ],
                        ),
                        if (user.reserveConfirmation != null &&
                            isLastPlayers == null) ...[
                          const SizedBox(height: 4),
                          loginBloc.state.user!.role == 0
                              ? _buildRoleIndicator(context)
                              : _buildStatusIndicator(context),
                        ]
                      ],
                    ),
                  ),
                  if (isLastPlayers == true)
                    Icon(
                      Icons.rate_review_outlined,
                      color: theme.colorScheme.primary,
                      size: 20,
                    ),
                  if (loginBloc.state.user!.role == 0)
                    IconButton(
                      icon: Icon(
                        Icons.edit,
                        color: theme.colorScheme.primary,
                      ),
                      onPressed: () {
                        mostrarUserAdminEdit(context, user.id);
                      },
                    ),
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
      return Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.8);
    }
    return user.reserveConfirmation ?? false
        ? const Color.fromARGB(255, 173, 255, 173).withOpacity(0.5)
        : Theme.of(context).colorScheme.errorContainer.withOpacity(0.5);
  }

  Color _getRoleColor(BuildContext context) {
    switch (user.role) {
      case 0:
        return const Color(0xFFFFC1C1).withOpacity(0.5); // Pastel red
      case 1:
        return const Color(0xFFADD8E6).withOpacity(0.5); // Pastel blue
      default:
        return const Color(0xFFB2F2BB).withOpacity(0.5); // Pastel green
    }
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

  Widget _buildRoleIndicator(BuildContext context) {
    Color roleColor;
    switch (user.role) {
      case 0: // Admin
        roleColor = Colors.red.withOpacity(0.1);
        break;
      case 1: // Owner
        roleColor = Colors.blue.withOpacity(0.1);
        break;
      default: // User
        roleColor = Colors.green.withOpacity(0.1);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: roleColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        user.role == 0
            ? AppLocalizations.of(context)!.role_admin
            : user.role == 1
                ? AppLocalizations.of(context)!.role_owner
                : AppLocalizations.of(context)!.role_user,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: roleColor.withAlpha((10 * 255).toInt()),
              fontWeight: FontWeight.w500,
            ),
      ),
    );
  }
}
