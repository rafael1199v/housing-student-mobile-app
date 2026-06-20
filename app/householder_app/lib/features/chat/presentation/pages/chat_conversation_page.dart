import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:housing_design_system/housing_design_system.dart';
import 'package:intl/intl.dart';

import '../../../../core/core.dart';
import '../../domain/entities/chat_message.dart';
import '../cubits/chat_conversation_cubit.dart';

const double kChatContentMaxWidth = 720;
const double kChatPaneHeaderHeight = 64;

class ChatConversationPage extends StatelessWidget {
  static const routeName = '/messages/:chatId';
  static String pathTo(int chatId) => '/messages/$chatId';

  const ChatConversationPage({
    super.key,
    required this.chatId,
    this.title,
  });

  final int chatId;
  final String? title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        title: Text(
          (title?.trim().isNotEmpty ?? false) ? title! : l10n.chatListTitle,
          style: theme.textTheme.titleLarge,
        ),
      ),
      body: ChatConversationView(chatId: chatId, title: title),
    );
  }
}

class ChatConversationView extends StatelessWidget {
  const ChatConversationView({
    super.key,
    required this.chatId,
    this.title,
    this.showHeader = false,
  });

  final int chatId;
  final String? title;
  final bool showHeader;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ChatConversationCubit>(
      create: (_) => GetIt.I<ChatConversationCubit>()..load(chatId),
      child: _ChatConversationView(title: title, showHeader: showHeader),
    );
  }
}

class _ChatConversationView extends StatefulWidget {
  const _ChatConversationView({this.title, this.showHeader = false});

  final String? title;
  final bool showHeader;

  @override
  State<_ChatConversationView> createState() => _ChatConversationViewState();
}

class _ChatConversationViewState extends State<_ChatConversationView> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onSend(String text) {
    context.read<ChatConversationCubit>().send(text);
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Column(
      children: [
        if (widget.showHeader) _PaneHeader(title: widget.title),
        Expanded(
          child: BlocBuilder<ChatConversationCubit, ChatConversationState>(
            builder: (context, state) {
              return switch (state) {
                ChatConversationLoaded(:final messages, :final currentUserId) =>
                  messages.isEmpty
                      ? Center(child: Text(l10n.chatNoMessages))
                      : _MessageList(
                          messages: messages,
                          currentUserId: currentUserId,
                        ),
                ChatConversationFailureState() =>
                  Center(child: Text(l10n.chatLoadError)),
                _ => const Center(child: CircularProgressIndicator()),
              };
            },
          ),
        ),
        Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: kChatContentMaxWidth),
            child: AppMessageComposer(
              controller: _controller,
              hintText: l10n.chatConversationHint,
              onSend: _onSend,
            ),
          ),
        ),
      ],
    );
  }
}

class _PaneHeader extends StatelessWidget {
  const _PaneHeader({this.title});

  final String? title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final l10n = AppLocalizations.of(context);
    return Container(
      decoration: BoxDecoration(
        color: cs.surface,
        border: Border(bottom: BorderSide(color: cs.outlineVariant, width: 1)),
      ),
      child: SafeArea(
        bottom: false,
        child: SizedBox(
          height: kChatPaneHeaderHeight,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: cs.surfaceContainerLow,
                  child: Icon(Icons.person_outline, color: cs.outline),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Text(
                    (title?.trim().isNotEmpty ?? false)
                        ? title!
                        : l10n.chatListTitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleLarge,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MessageList extends StatelessWidget {
  const _MessageList({required this.messages, required this.currentUserId});

  final List<ChatMessage> messages;
  final String? currentUserId;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: kChatContentMaxWidth),
        child: ListView.builder(
          reverse: true,
          padding: const EdgeInsets.all(AppSpacing.lg),
          itemCount: messages.length,
          itemBuilder: (context, index) {
            final message = messages[index];
            final isMine =
                currentUserId != null && message.senderId == currentUserId;
            return Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: AppChatBubble(
                message: message.message,
                isMine: isMine,
                timeLabel: DateFormat.Hm().format(message.createdAt),
                pending: message.status != ChatMessageStatus.sent,
              ),
            );
          },
        ),
      ),
    );
  }
}
