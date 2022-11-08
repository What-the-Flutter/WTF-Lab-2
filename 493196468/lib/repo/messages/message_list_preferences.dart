import 'package:shared_preferences/shared_preferences.dart';
import '../../chat/chat_entity/message.dart';

class MessageListPreferences {
  static const text = 'text';
  static const time = 'time';
  static const isSelected = 'isSelected';
  static const onEdit = 'onEdit';
  static late SharedPreferences _preferences;

  static Future init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  static Future delete(String chatTitle) async {
    _preferences.remove(text + chatTitle);
    _preferences.remove(time + chatTitle);
    _preferences.remove(isSelected + chatTitle);
    _preferences.remove(onEdit + chatTitle);
  }

  static Future setTexts(List<Message> messages, String chatTitle) async {
    var strList = <String>[];
    for (var element in messages) {
      strList.add(element.text);
    }
    await _preferences.setStringList(text + chatTitle, strList);
  }

  static Future setIsSelected(List<Message> messages, String chatTitle) async {
    var strList = <String>[];
    for (var element in messages) {
      strList.add(element.isSelected.toString());
    }
    await _preferences.setStringList(isSelected + chatTitle, strList);
  }

  static Future setOnEdit(List<Message> messages, String chatTitle) async {
    var strList = <String>[];
    for (var element in messages) {
      strList.add(element.onEdit.toString());
    }
    await _preferences.setStringList(onEdit + chatTitle, strList);
  }

  static Future setTime(List<Message> messages, String chatTitle) async {
    var strList = <String>[];
    for (var element in messages) {
      strList.add(element.sentTime.toString());
    }
    await _preferences.setStringList(time + chatTitle, strList);
  }

  static setMessages(List<Message> messages, String chatTitle) {
    setTexts(messages, chatTitle);
    setTime(messages, chatTitle);
    setIsSelected(messages, chatTitle);
    setOnEdit(messages, chatTitle);
  }

  static List<String>? getTexts(String chatTitle) => _preferences.getStringList(text + chatTitle);
  static List<String>? getTime(String chatTitle) => _preferences.getStringList(time + chatTitle);
  static List<String>? getIsSelected(String chatTitle) => _preferences.getStringList(isSelected + chatTitle);
  static List<String>? getOnEdit(String chatTitle) => _preferences.getStringList(onEdit + chatTitle);

  static List<Message> getMessages(String chatTitle) {
    List<String> texts = MessageListPreferences.getTexts(chatTitle) ?? [];
    List<String> times = MessageListPreferences.getTime(chatTitle) ?? [];
    List<String> isSelected = MessageListPreferences.getIsSelected(chatTitle) ?? [];
    List<String> onEdit = MessageListPreferences.getOnEdit(chatTitle) ?? [];
    List<Message> messageList = [];
    for (var i = 0; i < texts.length; i++) {
      messageList.add(
        Message(
          text: texts[i],
          sentTime: DateTime.parse(times[i]),
          isSelected: isSelected[i] == 'false' ? false : true,
          onEdit: onEdit[i] == 'false' ? false : true,
        ),
      );
    }
    return messageList;
  }
}