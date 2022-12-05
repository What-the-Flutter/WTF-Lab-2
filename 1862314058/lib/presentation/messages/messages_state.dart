import '../../data/models/message.dart';

class MessagesState {
  final List<Message> messageList;
  int? index;

  MessagesState({
    this.messageList = const [],
    this.index = 0,
  });

  MessagesState copyWith({
    List<Message>? messageList,
    int? index,
  }) {
    return MessagesState(
      messageList: messageList ?? this.messageList,
      index: index ?? this.index,
    );
  }
}
