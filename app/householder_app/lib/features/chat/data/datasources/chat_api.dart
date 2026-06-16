import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/chat_dtos.dart';

part 'chat_api.g.dart';

@RestApi()
abstract class ChatApi {
  factory ChatApi(Dio dio, {String baseUrl}) = _ChatApi;

  @POST('/api/chats')
  Future<ChatDto> startChat(@Body() StartChatRequest request);

  @GET('/api/chats')
  Future<List<ChatSummaryDto>> getChats();

  @GET('/api/chats/{chatId}/messages')
  Future<List<MessageDto>> getMessages(
    @Path('chatId') int chatId, {
    @Query('beforeMessageId') int? beforeMessageId,
    @Query('pageSize') int pageSize = 30,
  });

  @PUT('/api/chats/{chatId}/read')
  Future<bool> markRead(
    @Path('chatId') int chatId,
    @Body() MarkReadRequest request,
  );
}
