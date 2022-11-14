import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'theme.dart';

class ThemeStateChanger extends StatefulWidget {
  final Widget child;

  const ThemeStateChanger({Key? key, required this.child}) : super(key: key);

  @override
  State<ThemeStateChanger> createState() => _ThemeStateChangerState();
}

class _ThemeStateChangerState extends State<ThemeStateChanger> {
  ThemeData themeData = lightTheme;
  final themePreferences = ThemePreferences();

  @override
  void initState() {

    themePreferences.getTheme().then(
          (value) => {
            setState(() => themeData = value),
          },
        );
    super.initState();
  }

  void changeTheme() {
    setState(() {
      themeData = themeData == darkTheme ? lightTheme : darkTheme;
      themePreferences.saveTheme(themeData);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ThemeChanger(
      theme: themeData,
      stateWidget: this,
      child: widget.child,
    );
  }
}

class ThemeChanger extends InheritedWidget {
  final ThemeData theme;
  final _ThemeStateChangerState stateWidget;

  const ThemeChanger({
    super.key,
    required super.child,
    required this.theme,
    required this.stateWidget,
  });

  static ThemeChanger of(BuildContext context) {
    final result = context.dependOnInheritedWidgetOfExactType<ThemeChanger>();
    assert(result != null, 'No context');
    return result!;
  }

  @override
  bool updateShouldNotify(ThemeChanger oldWidget) => true;
}

class ThemePreferences {
  static const themeMode = 'themeMode';

  Future saveTheme(ThemeData themeData) async {
    final preferences = await SharedPreferences.getInstance();
    final stringThemeMode = themeData == lightTheme ? 'lightTheme' : 'darkTheme';
    preferences.setString(themeMode, stringThemeMode);
  }

  Future<ThemeData> getTheme() async {
    final preferences = await SharedPreferences.getInstance();
    final theme = preferences.getString(themeMode);
    return theme == 'lightTheme' ? lightTheme : darkTheme;
  }
}
