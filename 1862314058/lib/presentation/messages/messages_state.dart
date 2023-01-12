import '../../data/models/message.dart';

class MessagesState {
  final List<Message> messageList;
  final int? index;
  final bool editMode;

  MessagesState({
    this.messageList = const [],
    this.index = 0,
    required this.editMode,
  });

  MessagesState copyWith({
    List<Message>? messageList,
    int? index,
    bool? editMode,
  }) {
    return MessagesState(
      messageList: messageList ?? this.messageList,
      index: index ?? this.index,
      editMode: editMode ?? this.editMode,
    );
  }
}
