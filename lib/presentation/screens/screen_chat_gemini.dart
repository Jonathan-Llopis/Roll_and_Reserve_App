import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/chat/chat_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/chat/chat_event.dart';
import 'package:roll_and_reserve/presentation/blocs/chat/chat_state.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:roll_and_reserve/presentation/screens/screen_rol.dart';
import 'package:roll_and_reserve/presentation/widgets/screen_components/input_text_image.dart';

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
            InputTextImage(
              focusNode: _focusNode, isAssitant:  false,
            ),
          ],
        ));
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
