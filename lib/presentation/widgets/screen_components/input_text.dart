import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:roll_and_reserve/presentation/blocs/chat/chat_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/chat/chat_event.dart';
import 'package:roll_and_reserve/presentation/blocs/chat/chat_state.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class InputText extends StatefulWidget {
  const InputText(
      {super.key, required this.focusNode, required this.isRolPlay});
  final bool isRolPlay;
  final FocusNode focusNode;

  @override
  State<InputText> createState() => _InputTextState();
}

class _InputTextState extends State<InputText> {
  final SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  bool _isAvailable = false;
  final TextEditingController textController = TextEditingController();

  @override
  /// Initializes the speech-to-text functionality, requests the microphone
  /// permission if it has not been granted, and checks if the speech recognition
  /// service is available.
  ///
  /// This function is called when the widget is inserted into the tree.
  void initState() {
    super.initState();
    _checkPermissions();
    _initSpeech();
    _checkAvailability();
  }

  /// Checks if the microphone permission has been granted, and if not, requests it.
  /// If the permission is permanently denied, opens the app settings.
  void _checkPermissions() async {
    final status = await Permission.microphone.status;
    if (!status.isGranted) {
      final result = await Permission.microphone.request();
      if (result.isDenied) {
        print('Permiso del micrófono denegado permanentemente');
        if (result.isPermanentlyDenied) {
          await openAppSettings();
        }
      }
    }

    setState(() {});
  }

  /// Initializes the speech-to-text service.
  ///
  /// This function attempts to initialize the speech-to-text service and
  /// sets the [_speechEnabled] flag based on the success of the initialization.
  /// If the initialization is successful, the service will be ready to use,
  /// otherwise, an error message is printed and [_speechEnabled] is set to false.
  /// The state of the widget is updated after the initialization attempt.

  void _initSpeech() async {
    try {
      _speechEnabled = await _speechToText.initialize(
        onStatus: (status) => setState(() {}),
        onError: (error) => print('Error en reconocimiento: $error'),
      );
    } catch (e) {
      print('Error inicializando speech: $e');
      _speechEnabled = false;
    }
    setState(() {});
  }

  /// Checks if the speech recognition service is available.
  ///
  /// This function queries the speech recognition service to determine if it
  /// is available for use. The result is stored in the [_isAvailable] field.
  /// The state of the widget is updated with the result of the availability
  /// check.
  void _checkAvailability() async {
    _isAvailable = await _speechToText.isAvailable;
    print('Reconocimiento disponible: $_isAvailable');
    setState(() {});
  }

  /// Starts listening for speech recognition.
  ///
  /// This function starts listening for speech recognition if the
  /// [_speechEnabled] property is true. It sets the locale to 'es_ES',
  /// listens for 30 seconds, and enables partial results. After starting
  /// the listening process, it updates the state of the widget.
  void _startListening() async {
    if (!_speechEnabled) return;

    await _speechToText.listen(
      onResult: _onSpeechResult,
      localeId: 'es_ES',
      listenFor: const Duration(seconds: 30),
      partialResults: true,
    );
    setState(() {});
  }

  /// Stops listening for speech recognition.
  ///
  /// This function stops the speech recognition service from listening for
  /// speech. After stopping the service, it updates the state of the widget.
  void _stopListening() async {
    await _speechToText.stop();
    setState(() {});
  }

  /// Handles the speech recognition result.
  ///
  /// This function is called when the speech recognition service recognizes
  /// speech. It updates the text controller with the recognized words and
  /// checks if the result is final. If the result is final, it will update the
  /// text controller with the recognized words and send the message to the
  /// chat server. The state of the widget is updated after handling the result.
  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      textController.text = result.recognizedWords;
      if (result.finalResult) {
        textController.text = result.recognizedWords;
        _sendMessage(context, textController, widget.isRolPlay);
      }
    });
  }

  @override
  /// Builds the chat input field.
  ///
  /// This function builds a form field with a label, icon, and optional tap
  /// callback. It is used to input text messages that are sent to the AI
  /// assistant.
  ///
  /// The form field is decorated with a label and a border. It also has an
  /// icon on the left side that can be used to trigger a tap callback.
  ///
  /// The form field is validated using the [validator] passed to the
  /// constructor. If the validation fails, the error message is displayed
  /// below the form field.
  ///
  /// If [onTap] is provided, the field is read-only and the icon is colored
  /// with the primary color. Otherwise, the field is editable and the icon
  /// is colored with the onSurface color with 0.6 opacity.
  ///
  /// The form field is filled with the surface variant color with 0.3 opacity.
  ///
  /// The form field is wrapped in a [Padding] widget with a vertical padding of
  /// 2 and a horizontal padding of 20.
  ///
  /// The form field is also wrapped in a [SizedBox] widget with a width of
  /// double.infinity * 0.8.
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<ChatBloc, ChatState>(
      builder: (context, state) {
        return Container(
          decoration: BoxDecoration(
            border: Border(top: BorderSide(color: theme.dividerColor)),
            color: theme.colorScheme.surface,
          ),
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 150),
                  child: TextField(
                    controller: textController,
                    focusNode: widget.focusNode,
                    maxLines: null,
                    style: theme.textTheme.bodyLarge,
                    decoration: InputDecoration(
                      hintText: AppLocalizations.of(context)!.send_message,
                      hintStyle: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.4),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 14),
                      fillColor: Colors.grey[200],
                      filled: true,
                    ),
                    onSubmitted: (_) => _sendMessage(context, textController, widget.isRolPlay),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: state.isLoading
                    ? null
                    : IconButton(
                        onPressed: _speechEnabled
                            ? (_speechToText.isListening
                                ? _stopListening
                                : _startListening)
                            : null,
                        tooltip: 'Dictado',
                        icon: Icon(
                          _speechToText.isListening
                              ? Icons.mic
                              : Icons.mic_none,
                          color: _speechEnabled
                              ? theme.colorScheme.onPrimary
                              : theme.disabledColor,
                        ),
                        style: IconButton.styleFrom(
                          backgroundColor: _speechEnabled
                              ? theme.colorScheme.primary
                              : theme.colorScheme.surface.withOpacity(0.5),
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(16),
                        ),
                      ),
              ),
              const SizedBox(width: 8),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: state.isLoading
                    ? Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: theme.colorScheme.primary),
                      )
                    : IconButton.filled(
                        onPressed: () => _sendMessage(context, textController, widget.isRolPlay),
                        icon: Icon(Icons.send_rounded,
                            color: theme.colorScheme.onPrimary),
                        style: IconButton.styleFrom(
                          backgroundColor: theme.colorScheme.primary,
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(16),
                        ),
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

/// Sends a message using the provided [controller] and [context].
///
/// If [isRolPlay] is true, triggers a role play message event in the [ChatBloc].
/// Otherwise, it checks if the chat is empty. If it is, starts the chat with the
/// provided message; otherwise, sends the message.
///
/// Clears the [controller] after the message is sent and requests focus on the
/// input field.

  void _sendMessage(
      BuildContext context, TextEditingController controller, bool isRolPlay) {
    if (isRolPlay) {
      context
          .read<ChatBloc>()
          .add(OnRolPlaySendMessage(message: controller.text));
      controller.clear();
      widget.focusNode.requestFocus();
    } else {
      if (context.read<ChatBloc>().state.messages.isEmpty) {
        context
            .read<ChatBloc>()
            .add(OnChatStart(context: context, message: controller.text));
        controller.clear();
        widget.focusNode.requestFocus();
      } else {
        context
            .read<ChatBloc>()
            .add(OnChatSendMessage(message: controller.text));
        controller.clear();
        widget.focusNode.requestFocus();
      }
    }
  }
}
