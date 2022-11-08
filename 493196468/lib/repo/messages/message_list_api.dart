
import 'package:flutter/services.dart';
import '../../chat/chat_entity/message.dart';
import 'message_list_preferences.dart';

class MessageListApi {
  static List<Message> addMessage(String newMessage, String chatTitle) {
    List<Message> messages = MessageListPreferences.getMessages(chatTitle);
    messages.add(Message(text: newMessage));
    MessageListPreferences.setMessages(messages, chatTitle);
    return messages;
  }

  static List<Message> editMessage(String text, String chatTitle) {
    List<Message> messages = MessageListPreferences.getMessages(chatTitle);
    int editMessageIndex = messages.indexWhere((element) => element.isSelected);
    messages[editMessageIndex] =
        messages[editMessageIndex].copyWith(text: text, isSelected: false);
    MessageListPreferences.setMessages(messages, chatTitle);
    return messages;
  }

  static void copyMessage(String chatTitle) async {
    List<Message> messages = MessageListPreferences.getMessages(chatTitle);
    int editMessageIndex = messages.indexWhere((element) => element.isSelected);
    messages[editMessageIndex].text;
    await Clipboard.setData(
      ClipboardData(text: messages[editMessageIndex].text),
    );
  }

  static List<Message> deleteSelectedMessages(String chatTitle) {
    List<Message> messages = MessageListPreferences.getMessages(chatTitle);
    messages.removeWhere((element) => element.isSelected);
    MessageListPreferences.setMessages(messages, chatTitle);
    return messages;
  }

  static List<Message> selectMessage(int index, String chatTitle) {
    List<Message> messages = MessageListPreferences.getMessages(chatTitle);
    if (messages[index].isSelected) {
      messages[index] = messages[index].copyWith(isSelected: false);
    } else {
      messages[index] = messages[index].copyWith(isSelected: true);
    }
    MessageListPreferences.setMessages(messages, chatTitle);
    return messages;
  }

  static List<Message> unselectAllMessages(String chatTitle) {
    List<Message> messages = MessageListPreferences.getMessages(chatTitle);
    for (var i = 0; i < messages.length; i++) {
      messages[i] = messages[i].copyWith(isSelected: false);
    }
    MessageListPreferences.setMessages(messages, chatTitle);
    return messages;
  }

  static List<Message> startEditMessage(String chatTitle) {
    List<Message> messages = MessageListPreferences.getMessages(chatTitle);
    int editMessageIndex = messages.indexWhere((element) => element.isSelected);
    messages[editMessageIndex] =
        messages[editMessageIndex].copyWith(onEdit: true);
    MessageListPreferences.setMessages(messages, chatTitle);
    return messages;
  }

  static List<Message> completeEditMessage(String chatTitle) {
    List<Message> messages = MessageListPreferences.getMessages(chatTitle);
    int editMessageIndex = messages.indexWhere((element) => element.onEdit);
    messages[editMessageIndex] =
        messages[editMessageIndex].copyWith(onEdit: false);
    MessageListPreferences.setMessages(messages, chatTitle);
    return messages;
  }

  static List<Message> filterMessages(String filter, String chatTitle) {
    List<Message> messages = MessageListPreferences.getMessages(chatTitle);
    return messages
        .where((element) => element.text.startsWith(filter))
        .toList();
  }

  static List<Message> migrateMessages(String previousChat, String currentChat) {
    List<Message> previousMessages = MessageListPreferences.getMessages(previousChat);
    List<Message> currentMessages = MessageListPreferences.getMessages(currentChat);
    Iterable<Message> selectedMessages = previousMessages.where((element) => element.isSelected);
    MessageListPreferences.setMessages(previousMessages, previousChat);
    currentMessages.addAll(selectedMessages);
    MessageListPreferences.setMessages(currentMessages, currentChat);
    unselectAllMessages(currentChat);
    return previousMessages;
  }
}
