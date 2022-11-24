import 'package:bloc/bloc.dart';

import '../../data/message.dart';
import 'messages_state.dart';

class MessagesCubit extends Cubit<MessagesState> {
  MessagesCubit() : super(MessagesState());

  final List<Message> _messagesList = [
    Message(textMessage: '1', dateTime: DateTime.now())
  ];

  void init() => emit(state.copyWith(messageList: _messagesList));

  void addMessage(Message message) {
    state.messageList.add(message);
    emit(state.copyWith(messageList: state.messageList));
  }

  void editMessage(Message messageItem, int index) {
    state.messageList[index] = messageItem;
    emit(state.copyWith(messageList: state.messageList));
  }

  void deleteMessage(int index) {
    state.messageList.removeAt(index);
    emit(state.copyWith(messageList: state.messageList));
  }
}
