import 'package:json_annotation/json_annotation.dart';

part 'chat_dtos.g.dart';

@JsonSerializable(createToJson: false)
class ChatDto {
  final int chatId;
  final List<String> participantIds;

  const ChatDto({this.chatId = 0, this.participantIds = const []});

  factory ChatDto.fromJson(Map<String, dynamic> json) =>
      _$ChatDtoFromJson(json);
}

@JsonSerializable(createToJson: false)
class ChatSummaryDto {
  final int chatId;
  final String otherParticipantId;
  final String otherParticipantName;
  final String? lastMessage;
  final DateTime? lastMessageAt;
  final int unreadCount;

  const ChatSummaryDto({
    this.chatId = 0,
    this.otherParticipantId = '',
    this.otherParticipantName = '',
    this.lastMessage,
    this.lastMessageAt,
    this.unreadCount = 0,
  });

  factory ChatSummaryDto.fromJson(Map<String, dynamic> json) =>
      _$ChatSummaryDtoFromJson(json);
}

@JsonSerializable(createToJson: false)
class MessageDto {
  final int id;
  final int chatId;
  final String senderId;
  final String senderName;
  final String message;
  final DateTime createdAt;

  const MessageDto({
    this.id = 0,
    this.chatId = 0,
    this.senderId = '',
    this.senderName = '',
    this.message = '',
    required this.createdAt,
  });

  factory MessageDto.fromJson(Map<String, dynamic> json) =>
      _$MessageDtoFromJson(json);
}

@JsonSerializable(createFactory: false)
class StartChatRequest {
  final int? roomId;
  final String? participantUserId;

  const StartChatRequest({this.roomId, this.participantUserId});

  Map<String, dynamic> toJson() => _$StartChatRequestToJson(this);
}

@JsonSerializable(createFactory: false)
class MarkReadRequest {
  final int lastMessageId;

  const MarkReadRequest({required this.lastMessageId});

  Map<String, dynamic> toJson() => _$MarkReadRequestToJson(this);
}
