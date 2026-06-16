enum ChatMessageStatus { sent, sending, failed }

class ChatMessage {
  final int id;
  final int chatId;
  final String senderId;
  final String senderName;
  final String message;
  final DateTime createdAt;
  final ChatMessageStatus status;

  const ChatMessage({
    required this.id,
    required this.chatId,
    required this.senderId,
    required this.senderName,
    required this.message,
    required this.createdAt,
    this.status = ChatMessageStatus.sent,
  });

  ChatMessage copyWith({int? id, ChatMessageStatus? status}) => ChatMessage(
        id: id ?? this.id,
        chatId: chatId,
        senderId: senderId,
        senderName: senderName,
        message: message,
        createdAt: createdAt,
        status: status ?? this.status,
      );
}
