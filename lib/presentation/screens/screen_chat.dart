import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/chat/chat_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/chat/chat_event.dart';
import 'package:roll_and_reserve/presentation/blocs/chat/chat_state.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:roll_and_reserve/presentation/screens/screen_rol.dart';
import 'package:roll_and_reserve/presentation/widgets/screen_components/input_text.dart';

late bool isRestarting;

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final FocusNode _focusNode = FocusNode();

  @override

  /// Initializes the state for the chat screen, setting the `isRestarting`
  /// flag to `false` and calling the superclass's `initState` method.

  void initState() {
    isRestarting = false;
    super.initState();
  }

  @override

  /// Disposes of the resources used by the chat screen, specifically the
  /// focus node. This method is called when the widget is removed from the
  /// widget tree permanently, and it's the appropriate place to clean up
  /// resources that won't be needed anymore. Always call `super.dispose()`
  /// after disposing of your own resources.

  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override

  /// Builds the chat screen.
  ///
  /// This screen is used to chat with the AI assistant about game rules. It
  /// shows the conversation history at the top and an input field at the
  /// bottom.
  ///
  /// The title of the screen is "Ask AI about rules" and it shows a restart
  /// icon in the actions section that restarts the conversation when pressed.
  ///
  /// The input field is an [InputText] widget that allows the user to input
  /// text. The focus node is passed as a parameter so that the input field can
  /// request focus when the user starts typing.
  ///
  /// The conversation history is a [BodyMessages] widget that shows the
  /// conversation history. It is passed the [ChatBloc] as a parameter so that
  /// it can retrieve the messages from the bloc.
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.auto_awesome, color: theme.colorScheme.primary),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)!.ask_ai_about_rules,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                Text(
                  AppLocalizations.of(context)!.ai_assistant,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.6),
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
                  context.read<ChatBloc>().add(CleanChat());
                  setState(() => isRestarting = true);
                }),
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: BodyMessages(),
          ),
          InputText(focusNode: _focusNode, isRolPlay: false),
        ],
      ),
    );
  }
}

class BodyMessages extends StatelessWidget {
  const BodyMessages({super.key});

  @override

  /// Builds the body of the screen.
  ///
  /// If the state is loading and the screen was restarted, shows a loading
  /// indicator with a message. Otherwise, shows a list of messages with the
  /// messages from the state. The list is automatically scrolled to the bottom
  /// when the messages change.
  Widget build(BuildContext context) {
    final scrollController = ScrollController();
    return BlocBuilder<ChatBloc, ChatState>(
      builder: (context, state) {
        if (state.isLoading && isRestarting) {
          isRestarting = false;
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(
                    color: Theme.of(context).colorScheme.primary),
                const SizedBox(height: 16),
                Text(
                  AppLocalizations.of(context)!.loading_chat,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(0.6),
                      ),
                )
              ],
            ),
          );
        }

        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (scrollController.hasClients) {
            scrollController.animateTo(
              scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
          }
        });

        return ListView.builder(
          controller: scrollController,
          padding: const EdgeInsets.only(top: 16, bottom: 8),
          itemCount: state.messages.length,
          itemBuilder: (context, index) => ChatMessage(
            text: state.messages[index]['text'] ?? '',
            isFromUser: state.messages[index]['role'] == 'user',
          ),
        );
      },
    );
  }
}
