
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../home/home_entity/chat_card.dart';

class ChatListPreferences {
  static const title = 'title';
  static const subtitle = 'subtitle';
  static const isSelected = 'isSelected';
  static late SharedPreferences _preferences;
  static Future init() async {
    _preferences = await SharedPreferences.getInstance();
  }
  static Future delete() async {
    _preferences.remove(title);
    _preferences.remove(subtitle);
    _preferences.remove(isSelected);
  }
  static Future setTitles(List<ChatCard> list) async {
    var strList = <String>[];
    for (var element in list) {
      strList.add(element.title);
    }
    await _preferences.setStringList(title, strList);
  }

  static Future setSubtitles(List<ChatCard> list) async {
    var strList = <String>[];
    for (var element in list) {
      strList.add(element.subtitle);
    }
    await _preferences.setStringList(subtitle, strList);
  }

  static Future setIsSelected(List<ChatCard> list) async {
    var strList = <String>[];
    for (var element in list) {
      strList.add(element.isSelected.toString());
    }
    await _preferences.setStringList(isSelected, strList);
  }

  static List<String>? getTitles() => _preferences.getStringList(title);
  static List<String>? getSubtitles() => _preferences.getStringList(subtitle);
  static List<String>? getIsSelected() => _preferences.getStringList(isSelected);

  static List<ChatCard> getChatCards() {
    List<String> titles = ChatListPreferences.getTitles() ?? [];
    List<String> subtitles = ChatListPreferences.getSubtitles() ?? [];
    List<String> isSelected = ChatListPreferences.getIsSelected() ?? [];
    List<ChatCard> chatList = [];
    for (var i = 0; i < titles.length; i++) {
      chatList.add(
        ChatCard(
          icon: const Icon(Icons.ac_unit),
          title: titles[i],
          subtitle: subtitles[i],
          isSelected: isSelected[i] == 'false' ? false : true,
        ),
      );
    }
    return chatList;
  }

  static setChatCards(List<ChatCard> chatCards){
    setTitles(chatCards);
    setSubtitles(chatCards);
    setIsSelected(chatCards);
  }

}