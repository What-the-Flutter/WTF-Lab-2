import '/utils/chat_card.dart';
import 'firebase_implementation.dart';

class ChatsRepository {
  final FirebaseRepository _firebaseRepository;

  ChatsRepository(this._firebaseRepository);

  void listenForUpdates({required Function onUpdate}) =>
      _firebaseRepository.listenForUpdates(onUpdate: onUpdate);

  Future<List<ChatCard>> getAllChats() async =>
      _firebaseRepository.getAllChats();

  String? addChat(ChatCard chatCard) => _firebaseRepository.addChat(chatCard);

  void editChatCard(ChatCard chatCard) =>
      _firebaseRepository.editChatCard(chatCard);

  void deleteSelectedChats(List<ChatCard> chatCards) =>
      _firebaseRepository.deleteSelectedChats(chatCards);
}
