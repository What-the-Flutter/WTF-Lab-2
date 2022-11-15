import 'package:bloc/bloc.dart';
import '../repo/chats/chats_repository.dart';
import '../utils/chat_card.dart';

class HomeCubit extends Cubit<List<ChatCard>> {
  final ChatsRepository chatsRepository;

  HomeCubit(this.chatsRepository, List<ChatCard> chatCards) : super(chatCards);

  void emitAllChats() async => emit(await chatsRepository.getAllChats());

  void addChat({required ChatCard newChatCard}) {
    chatsRepository.addChat(newChatCard);
    emitAllChats();
  }

  ChatCard getSelectedChat() =>
      state.firstWhere((element) => element.isSelected);

  List<ChatCard> getSelectedChats() =>
      state.where((element) => element.isSelected).toList();

  void editChat(ChatCard chatCard) async {
    chatsRepository.editChatCard(chatCard.copyWith(isSelected: false));
    emitAllChats();
  }

  void deleteSelectedChats() {
    chatsRepository.deleteSelectedChats(
        state.where((element) => element.isSelected).toList());
    emitAllChats();
  }

  void selectChat(ChatCard chatCard) {
    chatsRepository.selectChat(chatCard);
    emitAllChats();
  }

  void unselectAllChats() {
    chatsRepository.unselectAllChats(
        state.where((element) => element.isSelected).toList());
    emitAllChats();
  }
}
