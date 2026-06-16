import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:housing_design_system/housing_design_system.dart';
import 'package:intl/intl.dart';

import '../../../../core/core.dart';
import '../../domain/entities/chat_summary.dart';
import '../cubits/chat_list_cubit.dart';
import 'chat_conversation_page.dart';

class ChatListPage extends StatelessWidget {
  static const routeName = '/messages';

  const ChatListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ChatListCubit>(
      create: (_) => GetIt.I<ChatListCubit>()..load(),
      child: const _ChatListView(),
    );
  }
}

class _ChatListView extends StatelessWidget {
  const _ChatListView();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        title: Text(
          l10n.chatListTitle,
          style: theme.textTheme.displaySmall?.copyWith(fontSize: 20),
        ),
      ),
      body: SafeArea(
        top: false,
        child: BlocBuilder<ChatListCubit, ChatListState>(
          builder: (context, state) {
            return switch (state) {
              ChatListLoaded(:final chats) => chats.isEmpty
                  ? _Empty(message: l10n.chatEmpty)
                  : _ChatList(chats: chats),
              ChatListFailureState() => _Error(
                  message: l10n.chatLoadError,
                  retryLabel: l10n.retry,
                  onRetry: () => context.read<ChatListCubit>().load(),
                ),
              _ => const Center(child: CircularProgressIndicator()),
            };
          },
        ),
      ),
    );
  }
}

class _ChatList extends StatelessWidget {
  const _ChatList({required this.chats});

  final List<ChatSummary> chats;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => context.read<ChatListCubit>().load(),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: ListView.separated(
            padding: const EdgeInsets.all(AppSpacing.lg),
            itemCount: chats.length,
            separatorBuilder: (_, _) => AppSpacing.gapSm,
            itemBuilder: (context, index) {
              final chat = chats[index];
              return AppChatListTile(
                title: chat.otherParticipantName.isEmpty
                    ? chat.otherParticipantId
                    : chat.otherParticipantName,
                subtitle: chat.lastMessage,
                timeLabel: _formatTime(chat.lastMessageAt),
                unreadCount: chat.unreadCount,
                onTap: () => context.push(
                  ChatConversationPage.pathTo(chat.chatId),
                  extra: chat.otherParticipantName,
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  static String? _formatTime(DateTime? date) {
    if (date == null) return null;
    final now = DateTime.now();
    final sameDay =
        date.year == now.year && date.month == now.month && date.day == now.day;
    return sameDay ? DateFormat.Hm().format(date) : DateFormat.MMMd().format(date);
  }
}

class _Empty extends StatelessWidget {
  const _Empty({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.chat_bubble_outline, size: 56, color: cs.outline),
            AppSpacing.gapLg,
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}

class _Error extends StatelessWidget {
  const _Error({
    required this.message,
    required this.retryLabel,
    required this.onRetry,
  });

  final String message;
  final String retryLabel;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message, textAlign: TextAlign.center),
            AppSpacing.gapLg,
            AppPrimaryButton(label: retryLabel, onPressed: onRetry),
          ],
        ),
      ),
    );
  }
}
