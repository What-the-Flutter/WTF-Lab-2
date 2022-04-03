import '../../models/chat.dart';
import '../firebase_provider.dart';

class ChatsRepository {
  final FirebaseProvider _db = FirebaseProvider();
  ChatsRepository();

  Future<List<Chat>> getChats() async {
    return await _db.getChats();
  }

  void insertChat(Chat chat) {
    _db.insertChat(chat);
  }

  void removeChat(Chat chat) {
    _db.removeChat(chat);
  }
}
