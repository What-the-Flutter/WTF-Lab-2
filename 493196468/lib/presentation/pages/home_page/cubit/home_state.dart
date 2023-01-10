part of 'home_cubit.dart';

class ChatsState {
  final List<ChatCard> chatCards;
  final int selectedTabIndex;

  const ChatsState(this.chatCards, this.selectedTabIndex);

  ChatsState copyWith({
    List<ChatCard>? chatCards,
    int? selectedTabIndex,
  }) {
    return ChatsState(
      chatCards ?? this.chatCards,
      selectedTabIndex ?? this.selectedTabIndex,
    );
  }

  @override
  String toString() {
    return chatCards.toString();
  }
}
