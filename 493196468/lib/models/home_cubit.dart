import 'package:bloc/bloc.dart';
import '../repo/firebase/chats_repository.dart';
import '../utils/chat_card.dart';

class HomeCubit extends Cubit<ChatsState> {
  final ChatsRepository chatsRepository = ChatsRepository();

  HomeCubit() : super(const ChatsState([]));

  void init() async => emit(ChatsState(await chatsRepository.getAllChats()));

  void checkForUpdates() async =>
      await chatsRepository.checkForUpdates(onUpdate: init);

  void emitAllChats() => emit(state.copyWith(state.chatCards));

  void addChat({required ChatCard newChatCard}) async {
    final id = await chatsRepository.addChat(newChatCard);
    var chats = state.chatCards;
    chats.add(newChatCard.copyWith(id: id));
    emit(ChatsState(chats));
  }

  ChatCard getSelectedChat() =>
      state.chatCards.firstWhere((element) => element.isSelected);

  List<ChatCard> getSelectedChats() =>
      state.chatCards.where((element) => element.isSelected).toList();

  void editChat(ChatCard chatCard) async {
    chatsRepository.editChatCard(chatCard.copyWith(isSelected: false));
    editChatInState(chatCard.copyWith(isSelected: false));
    emitAllChats();
  }

  void editChatInState(ChatCard editedChatCard) {
    final indexOfEditableChatCard = state.chatCards
        .indexWhere((element) => element.id == editedChatCard.id);
    state.chatCards[indexOfEditableChatCard] = editedChatCard;
  }

  void deleteSelectedChats() {
    final selectedChats =
        state.chatCards.where((element) => element.isSelected).toList();
    chatsRepository.deleteSelectedChats(selectedChats);
    for (var element in selectedChats) {
      state.chatCards.remove(element);
    }
    emitAllChats();
  }

  void selectChat(ChatCard chatCard) {
    chatCard.isSelected
        ? editChatInState(chatCard.copyWith(isSelected: false))
        : editChatInState(chatCard.copyWith(isSelected: true));
    emitAllChats();
  }

  void unselectAllChats() {
    final selectedChats =
        state.chatCards.where((element) => element.isSelected).toList();
    for (var element in selectedChats) {
      editChatInState(element.copyWith(isSelected: false));
    }
    emitAllChats();
  }
}

class ChatsState {
  final List<ChatCard> chatCards;

  const ChatsState(this.chatCards);

  ChatsState copyWith(
    List<ChatCard>? chatCards,
  ) {
    return ChatsState(
      chatCards ?? this.chatCards,
    );
  }

  @override
  String toString() {
    return chatCards.toString();
  }
}
