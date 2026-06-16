class ChatSummary {
  final int chatId;
  final String otherParticipantId;
  final String otherParticipantName;
  final String? lastMessage;
  final DateTime? lastMessageAt;
  final int unreadCount;

  const ChatSummary({
    required this.chatId,
    required this.otherParticipantId,
    required this.otherParticipantName,
    this.lastMessage,
    this.lastMessageAt,
    this.unreadCount = 0,
  });
}
