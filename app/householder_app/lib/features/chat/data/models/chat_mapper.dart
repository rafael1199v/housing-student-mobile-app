import '../../domain/entities/chat_message.dart';
import '../../domain/entities/chat_summary.dart';
import 'chat_dtos.dart';

extension ChatSummaryDtoMapper on ChatSummaryDto {
  ChatSummary toEntity() => ChatSummary(
        chatId: chatId,
        otherParticipantId: otherParticipantId,
        otherParticipantName: otherParticipantName,
        lastMessage: lastMessage,
        lastMessageAt: lastMessageAt?.toLocal(),
        unreadCount: unreadCount,
      );
}

extension MessageDtoMapper on MessageDto {
  ChatMessage toEntity() => ChatMessage(
        id: id,
        chatId: chatId,
        senderId: senderId,
        senderName: senderName,
        message: message,
        createdAt: createdAt.toLocal(),
      );
}
