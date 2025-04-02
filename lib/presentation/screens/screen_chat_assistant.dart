import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/chat/chat_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/chat/chat_event.dart';
import 'package:roll_and_reserve/presentation/blocs/chat/chat_state.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:roll_and_reserve/presentation/screens/screen_rol.dart';
import 'package:roll_and_reserve/presentation/widgets/screen_components/input_text_image.dart';

class ChatAssistantScreen extends StatefulWidget {
  const ChatAssistantScreen({super.key});

  @override
  State<ChatAssistantScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatAssistantScreen> {
  final FocusNode _focusNode = FocusNode();
  @override
  /// Initializes the state of the chat assistant screen.
  ///
  /// This function is called when the widget is inserted into the tree.
  ///
  /// If the chat messages are empty, it adds a [OnChatAssistantStart] event
  /// to the [ChatBloc] to start the chat with the assistant.
  void initState() {
    ChatBloc chatBloc = context.read<ChatBloc>();
    if (chatBloc.state.messagesAssistant.isEmpty) {
      context.read<ChatBloc>().add(OnChatAssistantStart(context: context));
    }

    super.initState();
  }

  @override
  /// Called when the widget is removed from the tree permanently.
  ///
  /// This is the opposite of [initState]. It is called when the widget is
  /// discarded, and is used to free up any resources that aren't needed
  /// anymore.
  ///
  /// In this case, it is used to remove the focus node from the widget tree.
  ///
  /// This method is called automatically when the widget is removed from the
  /// tree, but it is also safe to call manually if you want to prematurely
  /// release resources.
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  /// Builds the chat assistant screen.
  ///
  /// This screen is used to chat with the AI assistant. It shows the
  /// conversation history at the top and an input field at the bottom.
  ///
  /// The title of the screen is "Describe your move" and it shows a restart
  /// icon in the actions section that restarts the conversation when pressed.
  ///
  /// The input field is an [InputTextImage] widget that allows the user to
  /// input text and images. The focus node is passed as a parameter so that
  /// the input field can request focus when the user starts typing.
  ///
  /// The conversation history is a [BodyMessages] widget that shows the
  /// conversation history. It is passed the [ChatBloc] as a parameter so that
  /// it can retrieve the messages from the bloc.
  ///
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
                    AppLocalizations.of(context)!.describe_your_move,
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
                      .add(OnChatAssistantStart(context: context));
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
            InputTextImage(
              focusNode: _focusNode, isAssitant:  true,
            ),
          ],
        ));
  }
}

class BodyMessages extends StatelessWidget {
  const BodyMessages({super.key});

  @override
  /// Builds the widget tree for displaying chat messages with the assistant.
  ///
  /// This widget uses a [BlocBuilder] to listen to the [ChatBloc] and
  /// rebuilds when the chat state changes. It displays a [ListView] of
  /// messages if there are any messages from the assistant. The list
  /// automatically scrolls to the bottom when new messages arrive.
  ///
  /// If there are no messages, it displays a loading text.
  ///
  /// The [ScrollController] is used to manage the scrolling of the list view.
  ///
  /// Returns a [Widget] that displays the chat messages or a loading indicator.

  Widget build(BuildContext context) {
    ScrollController scrollController = ScrollController();

    return BlocBuilder<ChatBloc, ChatState>(
      builder: (context, state) {
        if (state.messagesAssistant.isNotEmpty) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (scrollController.hasClients) {
              scrollController
                  .jumpTo(scrollController.position.maxScrollExtent);
            }
          });

          return ListView.builder(
            controller: scrollController,
            itemBuilder: (context, index) {
              final text = state.messagesAssistant[index]['text'] ?? '';

              return ChatMessage(
                text: text,
                isFromUser: state.messagesAssistant[index]['role'] == 'user',
              );
            },
            itemCount: state.messagesAssistant.length,
          );
        } else {
          return Center(child: Text('Cargando chat...'));
        }
      },
    );
  }
}
