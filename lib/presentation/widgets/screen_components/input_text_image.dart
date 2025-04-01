// ignore_for_file: unused_field

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:roll_and_reserve/presentation/blocs/chat/chat_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/chat/chat_event.dart';
import 'package:roll_and_reserve/presentation/blocs/chat/chat_state.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class InputTextImage extends StatefulWidget {
  const InputTextImage(
      {super.key, required this.focusNode, required this.isAssitant});

  final bool isAssitant;
  final FocusNode focusNode;

  @override
  State<InputTextImage> createState() => _InputTextState();
}

class _InputTextState extends State<InputTextImage> {
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
      );
    } catch (e) {
      _speechEnabled = false;
    }
    setState(() {});
  }

  void _checkAvailability() async {
    _isAvailable = await _speechToText.isAvailable;

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
      }
    });
  }

  ImagePicker _picker = ImagePicker();
  XFile? _image;
  @override
  Widget build(BuildContext context) {
    TextEditingController textController = TextEditingController();
    final theme = Theme.of(context);
    return BlocBuilder<ChatBloc, ChatState>(
      builder: (context, state) {
        return Card(
          margin: EdgeInsets.zero,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 15,
            ),
            child: Row(
              children: [
                Expanded(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: 150,
                    ),
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
                      onSubmitted: (_) {
                        context.read<ChatBloc>().add(
                              OnChatGeminiSendMessage(
                                message: textController.text,
                              ),
                            );
                        textController.clear();
                        widget.focusNode.requestFocus();
                      },
                    ),
                  ),
                ),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: state.isLoading
                      ? null
                      : Stack(
                          children: [
                            IconButton(
                              onPressed: () {
                                showModalBottomSheet(
                                  context: context,
                                  builder: (context) => bottomSheet(),
                                );
                              },
                              icon: Icon(Icons.image, color: Colors.white),
                              style: IconButton.styleFrom(
                                backgroundColor: theme.colorScheme.primary,
                                shape: const CircleBorder(),
                                padding: const EdgeInsets.all(16),
                              ),
                            ),
                            if (_image != null)
                              Positioned(
                                right: 8,
                                top: 8,
                                child: Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                          ],
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
                SizedBox(width: 8),
                state.isLoading
                    ? CircularProgressIndicator()
                    : AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        child: state.isLoading
                            ? null
                            : IconButton(
                                onPressed: () async {
                                  List<ByteData>? imageBytes;
                                  if (_image != null) {
                                    imageBytes = [
                                      (await _image!.readAsBytes())
                                          .buffer
                                          .asByteData()
                                    ];
                                  }
                                  widget.isAssitant
                                      ? context.read<ChatBloc>().add(
                                            OnChatAssistantSendMessage(
                                              message: textController.text,
                                              imageBytes: imageBytes,
                                            ),
                                          )
                                      : context.read<ChatBloc>().add(
                                            OnChatGeminiSendMessage(
                                              message: textController.text,
                                              imageBytes: imageBytes,
                                            ),
                                          );
                                  textController.clear();
                                  _image = null;
                                },
                                icon: Icon(
                                  Icons.send,
                                  color: Colors.white,
                                ),
                                style: IconButton.styleFrom(
                                  backgroundColor:
                                      Theme.of(context).colorScheme.primary,
                                  shape: const CircleBorder(),
                                  padding: const EdgeInsets.all(16),
                                ),
                              ),
                      ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget bottomSheet() {
    return Container(
      height: 100.0,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: Column(children: <Widget>[
        Text(
          AppLocalizations.of(context)!.add_profile_image,
          style: TextStyle(
            fontSize: 20.0,
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
          TextButton.icon(
            icon: const Icon(Icons.camera),
            onPressed: () {
              takePhoto(ImageSource.camera);
              Navigator.pop(context);
            },
            label: Text(AppLocalizations.of(context)!.camera),
          ),
          const SizedBox(
            width: 10,
          ),
          TextButton.icon(
            icon: const Icon(Icons.image),
            onPressed: () {
              takePhoto(ImageSource.gallery);
              Navigator.pop(context);
            },
            label: Text(
              AppLocalizations.of(context)!.gallery,
            ),
          )
        ])
      ]),
    );
  }

  void takePhoto(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _image = pickedFile;
      });
    }
  }
}
