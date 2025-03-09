import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/chat/chat_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/chat/chat_event.dart';
import 'package:roll_and_reserve/presentation/blocs/chat/chat_state.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final FocusNode _focusNode = FocusNode();
  @override
  void initState() {
    context.read<ChatBloc>().add(OnChatStart(context: context));
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
        if (state.messages.isNotEmpty) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (scrollController.hasClients) {
              scrollController
                  .jumpTo(scrollController.position.maxScrollExtent);
            }
          });

          return ListView.builder(
            controller: scrollController,
            itemBuilder: (context, index) {
              final text = state.messages[index]['text'] ?? '';

              return ChatMessage(
                text: text,
                isFromUser: state.messages[index]['role'] == 'user',
              );
            },
            itemCount: state.messages.length,
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
                  ? const Color.fromARGB(255, 173, 216, 230) // Fondo más claro para el usuario
                  : const Color.fromARGB(255, 207, 206, 206), // Fondo más claro para el bot
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(isFromUser ? 20 : 5),
                  topRight: Radius.circular(isFromUser ? 5 : 20),
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
                border: Border.all(
                  color: isFromUser
                      ? Colors.blue.shade200 // Borde sutil para el usuario
                      : Colors.grey.shade300, // Borde sutil para el bot
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
                          ? Colors.blue.shade800 // Color más vibrante para el usuario
                          : Colors.grey.shade800, // Color más suave para el bot
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
                            ? Colors.blue.shade900 // Texto más oscuro para el usuario
                            : Colors.grey.shade900, // Texto más oscuro para el bot
                      ),
                      textAlign: WrapAlignment.spaceBetween, // Texto justificado
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