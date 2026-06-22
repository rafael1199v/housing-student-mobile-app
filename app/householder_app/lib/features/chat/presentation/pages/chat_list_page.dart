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

class _ChatListView extends StatefulWidget {
  const _ChatListView();

  @override
  State<_ChatListView> createState() => _ChatListViewState();
}

class _ChatListViewState extends State<_ChatListView> {
  static const double _listPaneWidth = 360;

  int? _selectedChatId;
  String? _selectedTitle;
  String? _selectedImageUrl;

  void _onSelect(BuildContext context, ChatSummary chat, {required bool expanded}) {
    final title = chat.otherParticipantName.isEmpty
        ? chat.otherParticipantId
        : chat.otherParticipantName;
    if (expanded) {
      setState(() {
        _selectedChatId = chat.chatId;
        _selectedTitle = title;
        _selectedImageUrl = chat.otherParticipantImageUrl;
      });
      return;
    }
    context.push(
      ChatConversationPage.pathTo(chat.chatId),
      extra: ChatConversationArgs(
        title: title,
        imageUrl: chat.otherParticipantImageUrl,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final isExpanded = Breakpoints.isExpanded(context);

    final listBody = BlocBuilder<ChatListCubit, ChatListState>(
      builder: (context, state) {
        return switch (state) {
          ChatListLoaded(:final chats) => chats.isEmpty
              ? _Empty(message: l10n.chatEmpty)
              : _ChatList(
                  chats: chats,
                  selectedChatId: isExpanded ? _selectedChatId : null,
                  onSelect: (chat) =>
                      _onSelect(context, chat, expanded: isExpanded),
                  centered: !isExpanded,
                ),
          ChatListFailureState() => _Error(
              message: l10n.chatLoadError,
              retryLabel: l10n.retry,
              onRetry: () => context.read<ChatListCubit>().load(),
            ),
          _ => const Center(child: CircularProgressIndicator()),
        };
      },
    );

    if (isExpanded) {
      // Master-detail: each pane owns its header so the vertical divider runs
      // edge to edge (no full-width AppBar cutting it off).
      return Scaffold(
        body: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              width: _listPaneWidth,
              child: Column(
                children: [
                  _ListPaneHeader(title: l10n.chatListTitle),
                  Expanded(child: listBody),
                ],
              ),
            ),
            const VerticalDivider(width: 1),
            Expanded(
              child: _selectedChatId == null
                  ? _ConversationPanePlaceholder(
                      message: l10n.chatSelectConversation,
                    )
                  : ChatConversationView(
                      key: ValueKey(_selectedChatId),
                      chatId: _selectedChatId!,
                      title: _selectedTitle,
                      imageUrl: _selectedImageUrl,
                      showHeader: true,
                    ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        title: Text(
          l10n.chatListTitle,
          style: theme.textTheme.displaySmall?.copyWith(fontSize: 20),
        ),
      ),
      body: SafeArea(top: false, child: listBody),
    );
  }
}

class _ListPaneHeader extends StatelessWidget {
  const _ListPaneHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
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
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                title,
                style: theme.textTheme.displaySmall?.copyWith(fontSize: 20),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ChatList extends StatelessWidget {
  const _ChatList({
    required this.chats,
    required this.onSelect,
    this.selectedChatId,
    this.centered = true,
  });

  final List<ChatSummary> chats;
  final ValueChanged<ChatSummary> onSelect;
  final int? selectedChatId;
  final bool centered;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final list = ListView.separated(
      padding: const EdgeInsets.all(AppSpacing.lg),
      itemCount: chats.length,
      separatorBuilder: (_, _) => AppSpacing.gapSm,
      itemBuilder: (context, index) {
        final chat = chats[index];
        final tile = AppChatListTile(
          title: chat.otherParticipantName.isEmpty
              ? chat.otherParticipantId
              : chat.otherParticipantName,
          subtitle: chat.lastMessage,
          timeLabel: _formatTime(chat.lastMessageAt),
          unreadCount: chat.unreadCount,
          avatar: avatarImageFromUrl(chat.otherParticipantImageUrl),
          onTap: () => onSelect(chat),
        );
        if (chat.chatId == selectedChatId) {
          return DecoratedBox(
            decoration: BoxDecoration(
              color: cs.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(AppRadii.lgValue),
            ),
            child: tile,
          );
        }
        return tile;
      },
    );

    return RefreshIndicator(
      onRefresh: () => context.read<ChatListCubit>().load(),
      child: centered
          ? Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 720),
                child: list,
              ),
            )
          : list,
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

class _ConversationPanePlaceholder extends StatelessWidget {
  const _ConversationPanePlaceholder({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return ColoredBox(
      color: cs.surfaceContainerLowest,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.forum_outlined, size: 56, color: cs.outline),
              AppSpacing.gapLg,
              Text(
                message,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
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
