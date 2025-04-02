import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:roll_and_reserve/presentation/blocs/chat/chat_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/chat/chat_event.dart';

class DialogCharacterDescription extends StatelessWidget {
  const DialogCharacterDescription({
    super.key,
    required this.controllerDescription,
    required this.controllerTheme,
  });

  final TextEditingController controllerDescription;
  final TextEditingController controllerTheme;

  @override
  /// Builds a dialog that allows the user to input a description of the
  /// adventurers and the setting of the game. This dialog is used to start
  /// a new game of Roll & Reserve.
  ///
  /// The dialog consists of two text fields: one for the adventurers'
  /// description and one for the setting description. The dialog is
  /// scrollable and has a start game button at the bottom.
  ///
  /// When the start game button is pressed, the [OnRolPlayStart] event is
  /// added to the [ChatBloc] with the text of the two text fields as the
  /// character and theme descriptions.
  ///
  /// The dialog is dismissed when the start game button is pressed.
  ///
  /// The dialog is centered on the screen and has a rounded rectangle shape.
  /// The text fields have a filled style and a rounded rectangle shape with
  /// a slightly transparent fill color. The text fields also have a
  /// floating label with a slight animation when the field is focused.
  /// The start game button is an elevated button with a rounded rectangle
  /// shape and a white foreground color.
  ///
  /// The dialog is themed according to the [Theme] of the provided
  /// [BuildContext].
  ///
  Widget build(BuildContext context) {
    return AlertDialog(
      icon: Icon(Icons.person_4_rounded,
          size: 32, color: Theme.of(context).colorScheme.primary),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      scrollable: true,
      title: Column(
        children: [
          Text(
            AppLocalizations.of(context)!.describe_your_adventure,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            AppLocalizations.of(context)!.enter_adventurers_description,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
        ],
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: controllerDescription,
              maxLines: 4,
              minLines: 3,
              autofocus: true,
              decoration: InputDecoration(
                floatingLabelBehavior: FloatingLabelBehavior.always,
                labelText: AppLocalizations.of(context)!.adventurers_description,
                alignLabelWithHint: true,
                prefixIcon: Icon(Icons.edit_note_rounded,
                    color: Theme.of(context).colorScheme.outline),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                      BorderSide(color: Theme.of(context).colorScheme.outline),
                ),
                filled: true,
                fillColor: Theme.of(context)
                    .colorScheme
                    .surfaceVariant
                    .withOpacity(0.4),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                    width: 2,
                  ),
                ),
              ),
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
            ),
            const SizedBox(height: 16),
            TextField(
              controller:
                  controllerTheme,
              maxLines: 4,
              minLines: 3,
              decoration: InputDecoration(
                floatingLabelBehavior: FloatingLabelBehavior.always,
                labelText: AppLocalizations.of(context)!.setting_description,
                alignLabelWithHint: true,
                prefixIcon: Icon(Icons.landscape_rounded,
                    color: Theme.of(context).colorScheme.outline),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                      BorderSide(color: Theme.of(context).colorScheme.outline),
                ),
                filled: true,
                fillColor: Theme.of(context)
                    .colorScheme
                    .surfaceVariant
                    .withOpacity(0.4),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                    width: 2,
                  ),
                ),
              ),
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
            ),
          ],
        ),
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: ElevatedButton.icon(
            icon: Icon(
              Icons.sports_esports_rounded,
              size: 20,
              color: Colors.white,
            ),
            label: Text(
              AppLocalizations.of(context)!.start_game.toUpperCase(),
              style: TextStyle(
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
            onPressed: () {
              if (controllerDescription.text.isNotEmpty &&
                  controllerTheme.text.isNotEmpty) {
                context.read<ChatBloc>().add(OnRolPlayStart(
                    context: context, character: controllerDescription.text, theme: controllerTheme.text));
                Navigator.of(context).pop();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
            ),
          ),
        ),
      ],
    );
  }
}
