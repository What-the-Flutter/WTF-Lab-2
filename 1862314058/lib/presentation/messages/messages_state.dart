import '../../data/models/message.dart';

class MessagesState {
  final List<Message> messageList;
  final int index;
  final bool editMode;
  final bool isBubbleAlignment;
  final String backgroundImage;

  MessagesState({
    this.messageList = const [],
    this.index = 0,
    required this.editMode,
    this.isBubbleAlignment = false,
    this.backgroundImage = '',
  });

  MessagesState copyWith({
    List<Message>? messageList,
    int? index,
    bool? editMode,
    bool? isBubbleAlignment,
    String? backgroundImage
  }) {
    return MessagesState(
      messageList: messageList ?? this.messageList,
      index: index ?? this.index,
      editMode: editMode ?? this.editMode,
      isBubbleAlignment: isBubbleAlignment ?? this.isBubbleAlignment,
      backgroundImage: backgroundImage ?? this.backgroundImage,
    );
  }
}
