import 'package:bloc/bloc.dart';

import '../../data/models/message.dart';
import '../../data/provider_db.dart';
import 'messages_state.dart';

class MessagesCubit extends Cubit<MessagesState> {
  MessagesCubit() : super(MessagesState());

  void init() async {
    emit(state.copyWith(
        messageList: await DBProvider.instance.getAllMessages()));
  }

  void addMessage(Message message) async {
    final newMessage = await DBProvider.instance.addMessage(message);
    final listM = state.messageList;
    listM.add(newMessage);
    emit(state.copyWith(messageList: listM));
  }

  void editMessage(Message messageItem, int index) {
    final listM = state.messageList;
    listM[index] = messageItem;
    emit(state.copyWith(messageList: listM));
  }

  void deleteMessage(int index) {
    final listM = state.messageList;
    listM.removeAt(index);
    emit(state.copyWith(messageList: listM));
  }
}
