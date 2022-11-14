import 'package:flutter/services.dart';

import '../../utils/message.dart';
import 'messages_data_base.dart';

class MessagesRepository {
  final database = MessagesDataBase();

  Future<List<Message>> getAllMessages() => database.getMessages();

  Future<List<Message>> getMessagesFromChat(int chatId) =>
      database.getMessagesFromChat(chatId);

  Future addMessage(Message message) => database.createMessage(message);

  Future editMessage(Message message) => database.updateMessage(message);

  Future deleteMessage(Message message) async =>
      database.deleteMessage(message.id!);

  Future selectMessage(Message message) => message.isSelected
      ? database.updateMessage(message.copyWith(isSelected: false))
      : database.updateMessage(message.copyWith(isSelected: true));

  Future unselectAllMessages(List<Message> messages) async {
    for (var element in messages) {
      database.updateMessage(element.copyWith(isSelected: false));
    }
  }

  Future copyMessage(Message message) async {
    await Clipboard.setData(
      ClipboardData(text: message.text),
    );
  }

  Future startEditMessage(Message message) async {
    database.updateMessage(message.copyWith(onEdit: true));
  }

  Future completeEditMessage(List<Message> messages) async {
    var message = messages.firstWhere((element) => element.onEdit);
    database.updateMessage(message.copyWith(onEdit: false, isSelected: false));
  }

  Future<List<Message>> filterMessages(String filter, int chatId) async {
    return (await getMessagesFromChat(chatId))
        .where((element) => element.text.startsWith(filter))
        .toList();
  }

  Future migrateMessages(int selectedChatId, List<Message> messages) async {
    var selectedMessages = messages.where((element) => element.isSelected);
    for (var element in selectedMessages) {
      database.updateMessage(
          element.copyWith(isSelected: false, chatId: selectedChatId));
    }
  }
}
