import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:housing_design_system/housing_design_system.dart';
import 'package:intl/intl.dart';

import '../../../../core/core.dart';
import '../../domain/entities/chat_message.dart';
import '../cubits/chat_conversation_cubit.dart';

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
    return BlocProvider<ChatConversationCubit>(
      create: (_) => GetIt.I<ChatConversationCubit>()..load(chatId),
      child: _ChatConversationView(title: title),
    );
  }
}

class _ChatConversationView extends StatefulWidget {
  const _ChatConversationView({this.title});

  final String? title;

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
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        title: Text(
          (widget.title?.trim().isNotEmpty ?? false)
              ? widget.title!
              : l10n.chatListTitle,
          style: theme.textTheme.titleLarge,
        ),
      ),
      body: Column(
        children: [
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
          AppMessageComposer(
            controller: _controller,
            hintText: l10n.chatConversationHint,
            onSend: _onSend,
          ),
        ],
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
        constraints: const BoxConstraints(maxWidth: 720),
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
