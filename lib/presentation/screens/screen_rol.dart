import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/chat/chat_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/chat/chat_state.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:roll_and_reserve/presentation/widgets/dialogs/dialog_character_description.dart';
import 'package:roll_and_reserve/presentation/widgets/screen_components/drawer_character_rol.dart';
import 'package:roll_and_reserve/presentation/widgets/screen_components/input_text.dart';

late bool isRestarting;

class RolScreen extends StatefulWidget {
  const RolScreen({super.key});

  @override
  State<RolScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<RolScreen> {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _controllerDescription = TextEditingController();
  final TextEditingController _controllerTheme = TextEditingController();

  @override

  /// If the list of messages is empty, show a dialog to the user asking
  /// for the character description and theme.
  ///
  /// This is called when the widget is inserted into the tree.
  void didChangeDependencies() {
    super.didChangeDependencies();
    ChatBloc chatBloc = BlocProvider.of<ChatBloc>(context);
    if (chatBloc.state.messagesRol.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return DialogCharacterDescription(
                controllerDescription: _controllerDescription, controllerTheme: _controllerTheme,);
          },
        );
      });
    }
  }

  @override
  /// Initializes the state of the chat screen.
  ///
  /// This function is called when the widget is inserted into the tree.
  ///
  /// It sets the [isRestarting] variable to false.
  void initState() {
    isRestarting = false;
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
  /// Builds the role-playing chat screen.
  ///
  /// This screen allows users to engage in a role-playing conversation with the AI.
  /// It displays the conversation history at the top and an input field at the bottom
  /// for user interaction.
  ///
  /// The title of the screen is "Play role with AI" and it features an icon alongside
  /// the title. The theme of the app is applied to the UI components.
  ///
  /// The [BodyMessages] widget presents the conversation history, while the [InputText]
  /// widget provides an input field for users, with a focus node to manage input focus.
  ///
  /// A [DrawerCharacterRol] is available as an end drawer, displaying character data
  /// from the [ChatBloc] state.

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
                            AppLocalizations.of(context)!.play_role_with_ai,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                body: Column(
                  children: [
                    Expanded(
                      child: BodyMessages(),
                    ),
                    InputText(focusNode: _focusNode, isRolPlay: true),
                  ],
                ),
                endDrawer: BlocBuilder<ChatBloc, ChatState>(
                  builder: (context, state) {
                    return DrawerCharacterRol(
                      characterData: state.character,
                    );
                  },
                ));
          }
  }


class BodyMessages extends StatelessWidget {
  const BodyMessages({super.key});

  @override
  /// Builds the message list view for the role-playing chat.
  ///
  /// This widget displays a loading indicator if the chat is loading or if the
  /// message list is empty. Otherwise, it presents a scrollable list of chat messages.
  ///
  /// The list view is automatically scrolled to the bottom when new messages are
  /// added. The [BlocBuilder] listens to changes in the [ChatBloc] state to update
  /// the UI when necessary.
  ///
  /// The [scrollController] is used to manage scrolling within the list view.

  Widget build(BuildContext context) {
    final scrollController = ScrollController();

    return BlocBuilder<ChatBloc, ChatState>(
      builder: (context, state) {
        if (state.isLoading && isRestarting || state.messagesRol.isEmpty) {
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
          itemCount: state.messagesRol.length,
          itemBuilder: (context, index) => ChatMessage(
            text: state.messagesRol[index]['text'] ?? '',
            isFromUser: state.messagesRol[index]['role'] == 'user',
          ),
        );
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
  /// Builds a chat message widget.
  ///
  /// This widget displays a single chat message within a styled container. The
  /// message is aligned to the start or end of the row based on whether it is
  /// from the user. The message text is rendered using Markdown, allowing for
  /// rich text formatting. The container's appearance, including its color and
  /// border radius, changes depending on who sent the message (user or narrator).
  ///
  /// The message displays the sender's identifier ("You" for user and "Narrator"
  /// for the other party) and the message content. The message bubble has a max
  /// width of 600 pixels and includes a shadow effect for messages not from the
  /// user.
  ///
  /// The [context] parameter is used to access theme data and localizations.

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
                        : AppLocalizations.of(context)!.narrator,
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
