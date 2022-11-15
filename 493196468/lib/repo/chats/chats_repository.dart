import '../../utils/chat_card.dart';
import 'chats_data_base.dart';

class ChatsRepository {
  final database = ChatsDataBase();

  Future<List<ChatCard>> getAllChats() => database.getChatCards();

  Future addChat(ChatCard chatCard) => database.createChatCard(chatCard);

  Future editChatCard(ChatCard chatCard) => database.updateChatCard(chatCard);

  Future deleteSelectedChats(List<ChatCard> chatCards) async {
    for (var element in chatCards) {
      database.deleteChatCard(element.id!);
    }
  }

  Future selectChat(ChatCard chatCard) => chatCard.isSelected
      ? database.updateChatCard(chatCard.copyWith(isSelected: false))
      : database.updateChatCard(chatCard.copyWith(isSelected: true));

  Future unselectAllChats(List<ChatCard> chatCards) async {
    for (var element in chatCards) {
      database.updateChatCard(element.copyWith(isSelected: false));
    }
  }
}
