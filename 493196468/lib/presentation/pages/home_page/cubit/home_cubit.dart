import 'package:bloc/bloc.dart';

import '/utils/chat_card.dart';
import '../../../../repo/firebase/chats_repository.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<ChatsState> {
  final ChatsRepository chatsRepository;

  HomeCubit(this.chatsRepository) : super(const ChatsState([], 0)) {
    _init();
  }

  void _init() async {
    _updateStateFromRepo();
    chatsRepository.listenForUpdates(onUpdate: _updateStateFromRepo);
  }

  void _updateStateFromRepo() async {
    emit(
      ChatsState(
        await chatsRepository.getAllChats(),
        0,
      ),
    );
  }

  void emitAllChats() {
    final chatCards = state.chatCards;
    emit(state.copyWith(chatCards: chatCards));
  }

  void addChat({required ChatCard newChatCard}) async {
    final id = await chatsRepository.addChat(newChatCard);
    var chats = state.chatCards;
    chats.add(newChatCard.copyWith(id: id));
    final newState = ChatsState(chats, state.selectedTabIndex);
    emit(newState);
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

  void changeTabIndex(int selectedTabIndex) {
    emit(state.copyWith(selectedTabIndex: selectedTabIndex));
  }
}
