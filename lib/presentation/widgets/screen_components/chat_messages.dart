
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ChatMessage extends StatelessWidget {
  final String text;
  final bool isFromUser;

  const ChatMessage({
    super.key,
    required this.text,
    required this.isFromUser,
  });

  @override
  /// Builds a single chat message.
  ///
  /// The message is a [Row] with a single flexible child. The flexible
  /// child is a [Container] with a [BoxDecoration] that has a
  /// [BorderRadius] and a [BoxShadow] if the message is not from the
  /// user. The container has a [Column] with a [Text] widget that shows
  /// the name of the user, and a [MarkdownBody] widget that shows the
  /// message text.
  ///
  /// The [MarkdownBody] widget is given a [MarkdownStyleSheet] that
  /// styles the text with the given theme.
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment:
            isFromUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Flexible(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 600),
              decoration: BoxDecoration(
                color: isFromUser
                    ? colors.primaryContainer
                    : colors.surfaceVariant,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(20),
                  topRight: const Radius.circular(20),
                  bottomLeft: Radius.circular(isFromUser ? 20 : 4),
                  bottomRight: Radius.circular(isFromUser ? 4 : 20),
                ),
                boxShadow: [
                  if (!isFromUser)
                    BoxShadow(
                      color: colors.shadow.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                ],
              ),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isFromUser
                        ? AppLocalizations.of(context)!.you
                        : AppLocalizations.of(context)!.ai_assistant,
                    style: theme.textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: isFromUser
                          ? colors.onPrimaryContainer
                          : colors.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 8),
                  MarkdownBody(
                    data: text,
                    styleSheet: MarkdownStyleSheet(
                      p: theme.textTheme.bodyLarge?.copyWith(
                        color: isFromUser
                            ? colors.onPrimaryContainer
                            : colors.onSurface,
                        height: 1.5,
                      ),
                      a: TextStyle(color: colors.primary),
                      code: TextStyle(
                        backgroundColor: colors.surfaceVariant,
                        color: colors.onSurface,
                        fontFamily: 'FiraCode',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
