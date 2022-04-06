import '../../models/chat.dart';
import '../firebase_provider.dart';

class ChatsRepository {
  final FirebaseProvider _db;
  ChatsRepository(this._db);

  Future<List<Chat>> getChats() async {
    return await _db.getChats();
  }

  void insertChat(Chat chat) {
    _db.insertChat(chat);
  }

  void removeChat(Chat chat) {
    _db.removeChat(chat);
  }

  void insertChats(List<Chat> list) {
    for (final element in list) {
      _db.insertChat(element);
    }
  }
}
