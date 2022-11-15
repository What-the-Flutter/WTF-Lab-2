import '../../utils/message.dart';
import '../data_base_provider.dart';

class MessagesDataBase {
  final _dbProvider = ChatsDataBaseProvider();

  Future<int> createMessage(Message message) async {
    final db = await _dbProvider.db;
    return db.insert(
      'messagesTable',
      message.toJson(),
    );
  }

  Future<List<Message>> getMessages() async {
    final db = await _dbProvider.db;
    var result = await db.query('messagesTable');
    return result.isNotEmpty ? result.map(Message.fromJson).toList() : [];
  }

  Future<List<Message>> getMessagesFromChat(int chatId) async {
    final db = await _dbProvider.db;
    var result = await db.query(
      'messagesTable',
      where: 'FK_chat_table = ?',
      whereArgs: [chatId],
    );
    return result.isNotEmpty ? result.map(Message.fromJson).toList() : [];
  }

  Future<int> updateMessage(Message message) async {
    final db = await _dbProvider.db;
    return await db.update(
      'messagesTable',
      message.toJson(),
      where: 'message_id = ?',
      whereArgs: [message.id],
    );
  }

  Future<int> deleteMessage(int id) async {
    final db = await _dbProvider.db;
    return await db.delete(
      'messagesTable',
      where: 'message_id = ?',
      whereArgs: [id],
    );
  }
}