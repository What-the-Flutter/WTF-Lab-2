import 'package:firebase_database/firebase_database.dart';

import '../../../utils/chat_card.dart';

class ChatsRepository {
  final ref = FirebaseDatabase.instance.ref();

  Future checkForUpdates({required Function onUpdate}) async {
    ref.child('chats').onValue.listen(
          (event) => onUpdate(),
    );
  }

  Future<List<ChatCard>> getAllChats() async {
    final snapshot = await ref.child('chats').get();

    final chats = <ChatCard>[];
    if (snapshot.exists) {
      for (final child in snapshot.children) {
        chats.add(ChatCard.fromJson(Map<String, dynamic>.from(child.value as Map<Object?, Object?>)));
      }
    } else {
      print('Error with firebase');
    }
    return chats;
  }

  String? addChat(ChatCard chatCard) {
    final newRef = ref.child('chats').push();
    newRef.set(chatCard.copyWith(id: newRef.key).toJson());
    return newRef.key;
  }

  void editChatCard(ChatCard chatCard) async {
    final snapshot = await ref.child('chats/${chatCard.id}');
    snapshot.update(chatCard.toJson());
  }

  void deleteSelectedChats(List<ChatCard> chatCards) async {
    for(var element in chatCards) {
      final snapshot = await ref.child('chats/${element.id}');
      snapshot.remove();
    }
  }
}
