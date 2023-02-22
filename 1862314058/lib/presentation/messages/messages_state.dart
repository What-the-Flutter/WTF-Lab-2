import '../../data/models/message.dart';

class MessagesState {
  final List<Message> messageList;
  final String postId;
  final bool isBubbleAlignment;
  final String backgroundImage;

  final int selectedMessage;
  final bool isSelected;
  final bool isEditing;

  MessagesState({
    this.messageList = const [],
    this.postId = '',
    this.isBubbleAlignment = false,
    this.backgroundImage = '',
    this.selectedMessage = 0,
    this.isSelected = false,
    this.isEditing = false,
  });

  MessagesState copyWith(
      {List<Message>? messageList,
      String? postId,
      bool? isBubbleAlignment,
      String? backgroundImage,
      int? selectedMessage,
      bool? isSelected,
        bool? isEditing,
      }) {
    return MessagesState(
      messageList: messageList ?? this.messageList,
      postId: postId ?? this.postId,
      isEditing: isEditing ?? this.isEditing,
      isBubbleAlignment: isBubbleAlignment ?? this.isBubbleAlignment,
      backgroundImage: backgroundImage ?? this.backgroundImage,
      selectedMessage: selectedMessage ?? this.selectedMessage,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}
