import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:roll_and_reserve/domain/entities/game_entity.dart';
import 'package:roll_and_reserve/presentation/blocs/game/game_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/game/game_event.dart';
import 'package:roll_and_reserve/presentation/blocs/game/game_state.dart';
import 'package:roll_and_reserve/presentation/blocs/game_rules/game_rules_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/game_rules/game_rules_event.dart';
import 'package:roll_and_reserve/presentation/blocs/game_rules/game_rules_state.dart';
import 'package:roll_and_reserve/presentation/widgets/genui/genui_renderer.dart';
import 'package:roll_and_reserve/presentation/widgets/genui/genui_skeleton_loader.dart';

class ScreenGameRulesChat extends StatefulWidget {
  final GameEntity? initialGame;

  const ScreenGameRulesChat({super.key, this.initialGame});

  @override
  State<ScreenGameRulesChat> createState() => _ScreenGameRulesChatState();
}

class _ScreenGameRulesChatState extends State<ScreenGameRulesChat> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Cargar catálogo de juegos para el selector
    context.read<GameBloc>().add(const GetAllGamesEvent());

    if (widget.initialGame != null) {
      context.read<GameRulesBloc>().add(SelectGameEvent(widget.initialGame!));
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _sendMessage() {
    final text = _textController.text.trim();
    if (text.isEmpty) return;

    _textController.clear();
    context.read<GameRulesBloc>().add(AskRuleQuestionEvent(text));
    _scrollToBottom();
  }

  void _openGameSelector(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (ctx) {
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          minChildSize: 0.4,
          maxChildSize: 0.9,
          expand: false,
          builder: (context, scrollController) {
            return BlocBuilder<GameBloc, GameState>(
              builder: (context, gameState) {
                return Column(
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 12.h),
                      width: 40.w,
                      height: 4.h,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade400,
                        borderRadius: BorderRadius.circular(2.r),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Row(
                        children: [
                          Icon(Icons.casino, color: Theme.of(context).primaryColor),
                          SizedBox(width: 8.w),
                          Text(
                            'Selecciona un Juego',
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 12.h),
                    Expanded(
                      child: () {
                        final games = gameState.games ?? const [];
                        if (games.isEmpty) {
                          return const Center(child: CircularProgressIndicator());
                        }
                        return ListView.separated(
                          controller: scrollController,
                          itemCount: games.length,
                          separatorBuilder: (_, __) => const Divider(height: 1),
                          itemBuilder: (context, index) {
                            final game = games[index];
                            return ListTile(
                              leading: const Icon(Icons.extension_rounded),
                              title: Text(
                                game.name,
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15.sp,
                                ),
                              ),
                              subtitle: Text(
                                game.description,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontSize: 12.sp),
                              ),
                              onTap: () {
                                this.context
                                    .read<GameRulesBloc>()
                                    .add(SelectGameEvent(game));
                                Navigator.pop(ctx);
                              },
                            );
                          },
                        );
                      }(),
                    ),
                  ],
                );
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return BlocConsumer<GameRulesBloc, GameRulesState>(
      listener: (context, state) {
        if (state.errorMessage != null && state.errorMessage!.isNotEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage!),
              backgroundColor: Colors.redAccent,
            ),
          );
        }
        _scrollToBottom();
      },
      builder: (context, state) {
        final selectedGame = state.selectedGame;

        return Scaffold(
          appBar: AppBar(
            title: InkWell(
              borderRadius: BorderRadius.circular(8.r),
              onTap: () => _openGameSelector(context),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Text(
                        selectedGame != null
                            ? selectedGame.name
                            : 'Seleccionar Juego',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Icon(Icons.arrow_drop_down, size: 20.sp),
                  ],
                ),
              ),
            ),
            actions: [
              IconButton(
                tooltip: 'Cambiar juego',
                icon: const Icon(Icons.sports_esports_outlined),
                onPressed: () => _openGameSelector(context),
              ),
              IconButton(
                tooltip: 'Limpiar conversación',
                icon: const Icon(Icons.refresh_rounded),
                onPressed: () {
                  context.read<GameRulesBloc>().add(const ClearConversationEvent());
                },
              ),
            ],
          ),
          body: Column(
            children: [
              if (selectedGame == null)
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(12.w),
                  color: theme.colorScheme.primary.withAlpha(20),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, color: theme.colorScheme.primary, size: 18.sp),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Text(
                          'Selecciona un juego arriba para contextualizar las reglas.',
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () => _openGameSelector(context),
                        child: const Text('Elegir'),
                      ),
                    ],
                  ),
                ),
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
                  itemCount: state.messages.length + (state.isLoading ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == state.messages.length && state.isLoading) {
                      return const GenUiSkeletonLoader();
                    }

                    final message = state.messages[index];
                    final isUser = message.role == 'user';

                    if (isUser) {
                      return Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          margin: EdgeInsets.only(
                            top: 6.h,
                            bottom: 6.h,
                            left: 50.w,
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 14.w,
                            vertical: 10.h,
                          ),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(16.r),
                              topRight: Radius.circular(16.r),
                              bottomLeft: Radius.circular(16.r),
                              bottomRight: Radius.circular(4.r),
                            ),
                          ),
                          child: Text(
                            message.text,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14.sp,
                              height: 1.3,
                            ),
                          ),
                        ),
                      );
                    } else {
                      return Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          margin: EdgeInsets.only(
                            top: 6.h,
                            bottom: 6.h,
                            right: 20.w,
                          ),
                          child: GenUiRenderer(
                            components: message.genUiComponents ?? const [],
                            summary: message.text,
                            isCached: message.isCached,
                            onChipTap: (question) {
                              context
                                  .read<GameRulesBloc>()
                                  .add(AskRuleQuestionEvent(question));
                              _scrollToBottom();
                            },
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E222A) : Colors.white,
                  border: Border(
                    top: BorderSide(color: Colors.grey.withAlpha(40)),
                  ),
                ),
                child: SafeArea(
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _textController,
                          textInputAction: TextInputAction.send,
                          onSubmitted: (_) => _sendMessage(),
                          decoration: InputDecoration(
                            hintText: selectedGame != null
                                ? 'Pregunta una regla de ${selectedGame.name}...'
                                : 'Pregunta cualquier duda de juego...',
                            hintStyle: TextStyle(fontSize: 13.5.sp),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 14.w,
                              vertical: 10.h,
                            ),
                            filled: true,
                            fillColor: isDark
                                ? const Color(0xFF282E3A)
                                : Colors.grey.shade100,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(24.r),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      IconButton.filled(
                        icon: const Icon(Icons.send_rounded),
                        onPressed: state.isLoading ? null : _sendMessage,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
