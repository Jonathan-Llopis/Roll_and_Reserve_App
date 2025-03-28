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
  const InputText({super.key, required this.focusNode});

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
  void initState() {
    super.initState();
    _checkPermissions();
    _initSpeech();
    _checkAvailability();
  }

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

  void _checkAvailability() async {
    _isAvailable = await _speechToText.isAvailable;
    print('Reconocimiento disponible: $_isAvailable');
    setState(() {});
  }

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

  void _stopListening() async {
    await _speechToText.stop();
    setState(() {});
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      textController.text = result.recognizedWords;
      if (result.finalResult) {
        textController.text = result.recognizedWords;
        _sendMessage(context, textController);
      }
    });
    
  }

  @override
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
                    onSubmitted: (_) => _sendMessage(context, textController),
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
                        onPressed: () => _sendMessage(context, textController),
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

  void _sendMessage(BuildContext context, TextEditingController controller) {
    if (context.read<ChatBloc>().state.messages.isEmpty) {
      context
          .read<ChatBloc>()
          .add(OnChatStart(context: context, message: controller.text));
      controller.clear();
      widget.focusNode.requestFocus();
    } else {
      context.read<ChatBloc>().add(OnChatSendMessage(message: controller.text));
      controller.clear();
      widget.focusNode.requestFocus();
    }
  }
}
