import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:roll_and_reserve/domain/usecases/chat_usecases/start_chat_gemini_usecases.dart';
import 'package:roll_and_reserve/presentation/blocs/chat/chat_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/chat/chat_event.dart';
import 'package:roll_and_reserve/presentation/blocs/chat/chat_state.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class ChatGeminiScreen extends StatefulWidget {
  const ChatGeminiScreen({super.key});

  @override
  State<ChatGeminiScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatGeminiScreen> {
  final FocusNode _focusNode = FocusNode();
  @override
  void initState() {
    ChatBloc chatBloc = context.read<ChatBloc>();
    if (chatBloc.state.messagesGemini.isEmpty) {
      context.read<ChatBloc>().add(OnChatGeminiStart(context: context));
    }

    super.initState();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              Icon(Icons.auto_awesome,
                  color: Theme.of(context).colorScheme.primary),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!.identify_board_games,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                  ),
                  Text(
                    AppLocalizations.of(context)!.ai_assistant,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withOpacity(0.6),
                        ),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            Tooltip(
              message: AppLocalizations.of(context)!.restart_conversation,
              child: IconButton(
                icon: Icon(Icons.restart_alt, size: 28),
                onPressed: () {
                  context
                      .read<ChatBloc>()
                      .add(OnChatGeminiStart(context: context));
                  setState(() {});
                },
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: BodyMessages(),
            ),
            InputText(
              focusNode: _focusNode,
            ),
          ],
        ));
  }
}

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
                              icon: Icon(
                                Icons.image,
                                color: _image == null
                                    ? Colors.white
                                    : theme.colorScheme.primary,
                              ),
                              style: IconButton.styleFrom(
                                backgroundColor: _image == null
                                    ? theme.colorScheme.primary
                                    : Colors.white,
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
                                  context.read<ChatBloc>().add(
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
                                  backgroundColor: Theme.of(context)
                                      .colorScheme
                                      .primary
                                      .withOpacity(0.8),
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

class BodyMessages extends StatelessWidget {
  const BodyMessages({super.key});

  @override
  Widget build(BuildContext context) {
    ScrollController scrollController = ScrollController();

    return BlocBuilder<ChatBloc, ChatState>(
      builder: (context, state) {
        if (state.messagesGemini.isNotEmpty) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (scrollController.hasClients) {
              scrollController
                  .jumpTo(scrollController.position.maxScrollExtent);
            }
          });

          return ListView.builder(
            controller: scrollController,
            itemBuilder: (context, index) {
              final text = state.messagesGemini[index]['text'] ?? '';

              return ChatMessage(
                text: text,
                isFromUser: state.messagesGemini[index]['role'] == 'user',
              );
            },
            itemCount: state.messagesGemini.length,
          );
        } else {
          return Center(child: Text('Cargando chat...'));
        }
      },
    );
  }
}

class ChatMessage extends StatelessWidget {
  final String text;
  final bool isFromUser;

  const ChatMessage({
    super.key,
    required this.text,
    required this.isFromUser,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        mainAxisAlignment:
            isFromUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Flexible(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 600),
              decoration: BoxDecoration(
                color: isFromUser
                    ? const Color.fromARGB(255, 173, 216, 230)
                    : const Color.fromARGB(255, 207, 206, 206),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(isFromUser ? 20 : 5),
                  topRight: Radius.circular(isFromUser ? 5 : 20),
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
                border: Border.all(
                  color:
                      isFromUser ? Colors.blue.shade200 : Colors.grey.shade300,
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(2, 4),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              margin: const EdgeInsets.only(bottom: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isFromUser ? 'You' : 'Bot',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      color: isFromUser
                          ? Colors.blue.shade800
                          : Colors.grey.shade800,
                    ),
                  ),
                  const SizedBox(height: 6),
                  MarkdownBody(
                    data: text,
                    styleSheet: MarkdownStyleSheet(
                      p: TextStyle(
                        fontSize: 16,
                        height: 1.5,
                        color: isFromUser
                            ? Colors.blue.shade900
                            : Colors.grey.shade900,
                      ),
                      textAlign: WrapAlignment.spaceBetween,
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
