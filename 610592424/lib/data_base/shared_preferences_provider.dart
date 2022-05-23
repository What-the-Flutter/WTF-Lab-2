import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesProvider{
  static late SharedPreferences _prefs;

  static Future<void> init() async => _prefs = await SharedPreferences.getInstance();

  ThemeData getTheme(){
    switch(_prefs.getString('theme')){
      case 'dark':
        return ThemeData.dark();
      default:
        return ThemeData.light();
    }
  }

  void changeTheme(){
    switch(_prefs.getString('theme')){
      case 'dark':
        _prefs.setString('theme', 'light');
        break;
      default:
        _prefs.setString('theme', 'dark');
        break;
    }
  }
}