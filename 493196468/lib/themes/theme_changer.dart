import 'package:flutter/material.dart';

import 'theme.dart';

class StateChanger extends StatefulWidget {
  final Widget child;

  StateChanger({Key? key, required this.child}) : super(key: key);

  @override
  State<StateChanger> createState() => _StateChangerState();
}

class _StateChangerState extends State<StateChanger> {
  ThemeData themeData = lightTheme;
  void changeTheme(){
    setState(() {
      themeData =  themeData == darkTheme ?  lightTheme : darkTheme;
    });
  }
  @override
  Widget build(BuildContext context) {
    return ThemeChanger(
      child: widget.child,
      theme: themeData,
      stateWidget: this,
    );
  }
}

class ThemeChanger extends InheritedWidget {
  final ThemeData theme;
  final _StateChangerState stateWidget;

  ThemeChanger({
    super.key,
    required super.child,
    required this.theme,
    required this.stateWidget,
  });

  static ThemeChanger of(BuildContext context) {
    final result =
        context.dependOnInheritedWidgetOfExactType<ThemeChanger>();
    assert(result != null, 'No context');
    return result!;
  }

  @override
  bool updateShouldNotify(ThemeChanger oldWidget) => true;
}