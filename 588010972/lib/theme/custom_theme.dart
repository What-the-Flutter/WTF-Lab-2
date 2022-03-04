import 'package:flutter/material.dart';
import 'app_theme.dart';
import 'inherited_custom_theme.dart';

class CustomTheme extends StatefulWidget {
  final ThemeName themeName;
  final Widget child;

  const CustomTheme({Key? key,
    required this.themeName,
    required this.child }) : super(key: key);


  @override
  CustomThemeState createState() => CustomThemeState();

  static ThemeData of(BuildContext context) {
    var inherited =
    (context.dependOnInheritedWidgetOfExactType<CustomThemeInherited>()!);
    return inherited.themeState.getTheme;
  }

  static CustomThemeState instanceOf(BuildContext context) {
    CustomThemeInherited? inherited =
    (context.dependOnInheritedWidgetOfExactType<CustomThemeInherited>()!);
    return inherited.themeState;
  }

}

class CustomThemeState extends State<CustomTheme> {
  late ThemeData _themeData;
  bool currentTheme = true;

  ThemeData get getTheme => _themeData;

  @override
  void initState() {
   _themeData = AppThemes.changeTheme(widget.themeName);
    super.initState();
  }


  void changeTheme(ThemeName value){
    currentTheme
        ? setState(() => _themeData = AppThemes.changeTheme(ThemeName.dark))
        : setState(() => _themeData = AppThemes.changeTheme(ThemeName.light));
    currentTheme ? currentTheme = false : currentTheme = true;
  }

  @override
  Widget build(BuildContext context) {
    return CustomThemeInherited(
        child: widget.child,
        themeState: this,
      key: UniqueKey(),);
  }
}
