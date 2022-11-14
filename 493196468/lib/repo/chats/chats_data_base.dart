import '../../utils/chat_card.dart';
import '../data_base_provider.dart';

class ChatsDataBase {
  final _dbProvider = ChatsDataBaseProvider();

  Future<int> createChatCard(ChatCard chatCard) async {
    final db = await _dbProvider.db;
    return db.insert(
      'chatsTable',
      chatCard.toJson(),
    );
  }

  Future<List<ChatCard>> getChatCards() async {
    final db = await _dbProvider.db;
    var result = await db.query('chatsTable');
    return result.isNotEmpty ? result.map(ChatCard.fromJson).toList() : [];
  }

  Future<int> updateChatCard(ChatCard chatCard) async {
    final db = await _dbProvider.db;
    return await db.update(
      'chatsTable',
      chatCard.toJson(),
      where: 'chat_id = ?',
      whereArgs: [chatCard.id],
    );
  }

  Future<int> deleteChatCard(int id) async {
    final db = await _dbProvider.db;
    return await db.delete(
      'chatsTable',
      where: 'chat_id = ?',
      whereArgs: [id],
    );
  }
}
