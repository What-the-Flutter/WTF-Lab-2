import '../../home/home_entity/chat_card.dart';
import 'chat_list_preferences.dart';


class ChatListApi {

  static List<ChatCard> addChat(ChatCard newChatCard) {
    List<ChatCard> chatCards = ChatListPreferences.getChatCards();
    chatCards.add(newChatCard);
    ChatListPreferences.setChatCards(chatCards);
    return chatCards;
  }
  static List<ChatCard> editChat(String title) {
    List<ChatCard> chatCards = ChatListPreferences.getChatCards();
    int editChatCardIndex = chatCards.indexWhere((element) => element.isSelected);
    chatCards[editChatCardIndex] = chatCards[editChatCardIndex].copyWith(title: title, isSelected: false);
    ChatListPreferences.setChatCards(chatCards);
    return chatCards;
  }
  static List<ChatCard> deleteSelectedChats() {
    List<ChatCard> chatCards = ChatListPreferences.getChatCards();
    chatCards.removeWhere((element) => element.isSelected);
    ChatListPreferences.setChatCards(chatCards);
    return chatCards;
  }

  static List<ChatCard> selectChat(int index) {
    List<ChatCard> chatCards = ChatListPreferences.getChatCards();
    if(chatCards[index].isSelected){
      chatCards[index] = chatCards[index].copyWith(isSelected: false);
    } else {
      chatCards[index] = chatCards[index].copyWith(isSelected: true);
    }
    ChatListPreferences.setChatCards(chatCards);
    return chatCards;
  }

  static List<ChatCard> unselectAllChats() {
    List<ChatCard> chatCards = ChatListPreferences.getChatCards();
    for(var i = 0; i < chatCards.length; i++){
      chatCards[i] = chatCards[i].copyWith(isSelected: false);
    }
    ChatListPreferences.setChatCards(chatCards);
    return chatCards;
  }
}