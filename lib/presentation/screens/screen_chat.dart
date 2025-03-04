import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/chat/chat_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/chat/chat_event.dart';
import 'package:roll_and_reserve/presentation/blocs/chat/chat_state.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final FocusNode _focusNode = FocusNode();
  @override
  void initState() {
    context.read<ChatBloc>().add(const OnChatStart());
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
          title: Text("AI Chat"),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Text(
                "Ayuda",
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

class InputText extends StatelessWidget {
  const InputText({super.key, required this.focusNode});

  final FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    TextEditingController textController = TextEditingController();
    return BlocBuilder<ChatBloc, ChatState>(
      builder: (context, state) {
        return Card(
          margin: EdgeInsets.zero,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 25,
              horizontal: 15,
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    autofocus: true,
                    focusNode: focusNode,
                    controller: textController,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(15),
                      hintText: 'Envia un mensaje',
                      border: OutlineInputBorder(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(14),
                        ),
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(14),
                        ),
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                    ),
                    onSubmitted: (_) {
                      context.read<ChatBloc>().add(
                            OnChatSendMessage(
                              message: textController.text,
                            ),
                          );
                      textController.clear();
                      focusNode.requestFocus();
                    },
                  ),
                ),
                const SizedBox.square(
                  dimension: 15,
                ),
                state.isLoading
                    ? CircularProgressIndicator()
                    : IconButton(
                        onPressed: () {
                          context.read<ChatBloc>().add(
                                OnChatSendMessage(
                                  message: textController.text,
                                ),
                              );
                          textController.clear();
                        },
                        icon: Icon(
                          Icons.send,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      )
              ],
            ),
          ),
        );
      },
    );
  }
}

class BodyMessages extends StatelessWidget {
  const BodyMessages({super.key});

  @override
  Widget build(BuildContext context) {
    ScrollController scrollController = ScrollController();

    return BlocBuilder<ChatBloc, ChatState>(
      builder: (context, state) {
        if (state.chat != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (scrollController.hasClients) {
              scrollController
                  .jumpTo(scrollController.position.maxScrollExtent);
            }
          });

          return ListView.builder(
            controller: scrollController,
            itemBuilder: (context, index) {
              if (index == 0) {
                return const SizedBox.shrink();
              }
              final content = state.chat.history.toList()[index];
              final text = content.parts
                  .whereType<TextPart>()
                  .map((e) => e.text)
                  .join("");

              return ChatMessage(
                text: text,
                isFromUser: content.role == 'user',
              );
            },
            itemCount: state.chat.history.length,
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
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        mainAxisAlignment:
            isFromUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Flexible(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 600),
              decoration: BoxDecoration(
                color: isFromUser ? Colors.blue[100] : Colors.grey[300],
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: Offset(2, 2),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(
                vertical: 15,
                horizontal: 20,
              ),
              margin: const EdgeInsets.only(bottom: 8),
              child: MarkdownBody(
                data: text,
                styleSheet: MarkdownStyleSheet(
                  p: TextStyle(
                    fontSize: 16,
                    color: isFromUser ? Colors.black87 : Colors.black54,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
