import 'package:bloc/bloc.dart';
import '../../repo/messages/message_list_api.dart';
import '../chat_entity/message.dart';

class MessageCubit extends Cubit<List<Message>> {
  MessageCubit(super.initialState);

  void addMessage({required String newMessage, required String chatTitle}) =>
      emit(MessageListApi.addMessage(newMessage, chatTitle));

  void editMessage(String text, String chatTitle) =>
      emit(MessageListApi.editMessage(text, chatTitle));

  void copyMessage(String chatTitle) => MessageListApi.copyMessage(chatTitle);

  void deleteSelectedMessage(String chatTitle) =>
      emit(MessageListApi.deleteSelectedMessages(chatTitle));

  void selectMessage(int index, String chatTitle) =>
      emit(MessageListApi.selectMessage(index, chatTitle));

  void unselectAllMessages(String chatTitle) =>
      emit(MessageListApi.unselectAllMessages(chatTitle));

  void startEditMessage(String chatTitle) =>
      emit(MessageListApi.startEditMessage(chatTitle));

  void completeEditMessage(String chatTitle) =>
      emit(MessageListApi.completeEditMessage(chatTitle));

  void filterMessages(String filter, String chatTitle) =>
      emit(MessageListApi.filterMessages(filter, chatTitle));

  void migrateMessages(String previousChat, String currentChat) {
    MessageListApi.migrateMessages(previousChat, currentChat);
    deleteSelectedMessage(previousChat);
  }
}
