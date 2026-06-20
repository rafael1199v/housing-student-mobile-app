import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

import '../../../domain/entities/chat_message.dart';
import '../../../domain/entities/chat_summary.dart';
import 'chat_local_data_source.dart';

class SqfliteChatLocalDataSource implements ChatLocalDataSource {
  SqfliteChatLocalDataSource();

  Database? _db;

  Future<Database> _database() async {
    final existing = _db;
    if (existing != null) return existing;

    final dir = await getDatabasesPath();
    final db = await openDatabase(
      p.join(dir, 'chat_cache.db'),
      version: 1,
      onCreate: (db, _) async {
        await db.execute('''
          CREATE TABLE chats(
            chatId INTEGER PRIMARY KEY,
            otherParticipantId TEXT,
            otherParticipantName TEXT,
            lastMessage TEXT,
            lastMessageAt INTEGER,
            unreadCount INTEGER
          )
        ''');
        await db.execute('''
          CREATE TABLE messages(
            id INTEGER,
            chatId INTEGER,
            senderId TEXT,
            senderName TEXT,
            message TEXT,
            createdAt INTEGER,
            PRIMARY KEY(chatId, id)
          )
        ''');
        await db.execute('''
          CREATE TABLE outbox(
            localId INTEGER PRIMARY KEY AUTOINCREMENT,
            chatId INTEGER,
            message TEXT,
            createdAt INTEGER
          )
        ''');
      },
    );
    _db = db;
    return db;
  }

  @override
  Future<void> cacheChats(List<ChatSummary> chats) async {
    final db = await _database();
    final batch = db.batch();
    batch.delete('chats');
    for (final c in chats) {
      batch.insert('chats', {
        'chatId': c.chatId,
        'otherParticipantId': c.otherParticipantId,
        'otherParticipantName': c.otherParticipantName,
        'lastMessage': c.lastMessage,
        'lastMessageAt': c.lastMessageAt?.millisecondsSinceEpoch,
        'unreadCount': c.unreadCount,
      });
    }
    await batch.commit(noResult: true);
  }

  @override
  Future<List<ChatSummary>> readChats() async {
    final db = await _database();
    final rows = await db.query('chats', orderBy: 'lastMessageAt DESC');
    return rows
        .map(
          (r) => ChatSummary(
            chatId: r['chatId'] as int,
            otherParticipantId: r['otherParticipantId'] as String? ?? '',
            otherParticipantName: r['otherParticipantName'] as String? ?? '',
            lastMessage: r['lastMessage'] as String?,
            lastMessageAt: _toDate(r['lastMessageAt'] as int?),
            unreadCount: r['unreadCount'] as int? ?? 0,
          ),
        )
        .toList();
  }

  @override
  Future<void> cacheMessages(int chatId, List<ChatMessage> messages) async {
    final db = await _database();
    final batch = db.batch();
    batch.delete('messages', where: 'chatId = ?', whereArgs: [chatId]);
    for (final m in messages) {
      batch.insert('messages', {
        'id': m.id,
        'chatId': m.chatId,
        'senderId': m.senderId,
        'senderName': m.senderName,
        'message': m.message,
        'createdAt': m.createdAt.millisecondsSinceEpoch,
      }, conflictAlgorithm: ConflictAlgorithm.replace);
    }
    await batch.commit(noResult: true);
  }

  @override
  Future<List<ChatMessage>> readMessages(int chatId) async {
    final db = await _database();
    final rows = await db.query(
      'messages',
      where: 'chatId = ?',
      whereArgs: [chatId],
      orderBy: 'id DESC',
    );
    return rows
        .map(
          (r) => ChatMessage(
            id: r['id'] as int,
            chatId: r['chatId'] as int,
            senderId: r['senderId'] as String? ?? '',
            senderName: r['senderName'] as String? ?? '',
            message: r['message'] as String? ?? '',
            createdAt:
                _toDate(r['createdAt'] as int?) ?? DateTime.now(),
          ),
        )
        .toList();
  }

  @override
  Future<void> appendMessage(ChatMessage message) async {
    final db = await _database();
    await db.insert('messages', {
      'id': message.id,
      'chatId': message.chatId,
      'senderId': message.senderId,
      'senderName': message.senderName,
      'message': message.message,
      'createdAt': message.createdAt.millisecondsSinceEpoch,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  @override
  Future<void> clear() async {
    final db = await _database();
    final batch = db.batch();
    batch.delete('chats');
    batch.delete('messages');
    batch.delete('outbox');
    await batch.commit(noResult: true);
  }

  @override
  Future<void> enqueueOutgoing(int chatId, String message) async {
    final db = await _database();
    await db.insert('outbox', {
      'chatId': chatId,
      'message': message,
      'createdAt': DateTime.now().millisecondsSinceEpoch,
    });
  }

  @override
  Future<List<OutgoingMessage>> readOutgoing() async {
    final db = await _database();
    final rows = await db.query('outbox', orderBy: 'localId ASC');
    return rows
        .map(
          (r) => OutgoingMessage(
            id: r['localId'] as int,
            chatId: r['chatId'] as int,
            message: r['message'] as String? ?? '',
          ),
        )
        .toList();
  }

  @override
  Future<void> removeOutgoing(int id) async {
    final db = await _database();
    await db.delete('outbox', where: 'localId = ?', whereArgs: [id]);
  }

  static DateTime? _toDate(int? millis) =>
      millis == null ? null : DateTime.fromMillisecondsSinceEpoch(millis);
}
