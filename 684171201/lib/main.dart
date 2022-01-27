import 'package:flutter/material.dart';
import 'package:flutter_application_5/screens/home_screen.dart';

var themeData = ThemeData(
  brightness: Brightness.light,
  primarySwatch: Colors.teal,
);

var themeDark = ThemeData(
  brightness: Brightness.dark,
);

var themeLight = ThemeData(
  brightness: Brightness.light,
  primarySwatch: Colors.teal,
);

List<EventGroup> eventGroups = [
  EventGroup(3, 'Travel'),
];

List<Icon> availableIcons = const [
  Icon(Icons.archive),
  Icon(Icons.delete),
  Icon(Icons.add),
  Icon(Icons.add),
  Icon(Icons.archive),
  Icon(Icons.delete),
  Icon(Icons.add),
  Icon(Icons.add),
  Icon(Icons.archive),
  Icon(Icons.delete),
  Icon(Icons.add),
  Icon(Icons.add),
  Icon(Icons.archive),
  Icon(Icons.delete),
  Icon(Icons.add),
  Icon(Icons.add),
  Icon(Icons.add),
  Icon(Icons.archive),
  Icon(Icons.delete),
  Icon(Icons.add),
  Icon(Icons.add),
  Icon(Icons.add),
  Icon(Icons.archive),
  Icon(Icons.delete),
  Icon(Icons.add),
  Icon(Icons.add),
  Icon(Icons.add),
  Icon(Icons.archive),
  Icon(Icons.delete),
  Icon(Icons.add),
  Icon(Icons.add),
  Icon(Icons.add),
  Icon(Icons.archive),
  Icon(Icons.delete),
  Icon(Icons.add),
  Icon(Icons.add),
  Icon(Icons.add),
  Icon(Icons.archive),
  Icon(Icons.delete),
  Icon(Icons.add),
  Icon(Icons.add),
  Icon(Icons.add),
  Icon(Icons.archive),
  Icon(Icons.delete),
  Icon(Icons.add),
  Icon(Icons.add),
  Icon(Icons.add),
  Icon(Icons.archive),
  Icon(Icons.delete),
  Icon(Icons.add),
  Icon(Icons.add),
];

bool isDarkTheme = true;

void main() {
  runApp(
    ThemeSwitcherWidget(
      initialTheme: themeData,
      child: const MyApp(),
    ),
  );
}

class ThemeSwitcher extends InheritedWidget {
  final _ThemeSwitcherWidgetState data;

  const ThemeSwitcher({
    Key? key,
    required this.data,
    required Widget child,
  }) : super(key: key, child: child);

  static _ThemeSwitcherWidgetState of(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<ThemeSwitcher>(
            aspect: ThemeSwitcher) as ThemeSwitcher)
        .data;
  }

  @override
  bool updateShouldNotify(ThemeSwitcher oldWidget) {
    return this != oldWidget;
  }
}

class ThemeSwitcherWidget extends StatefulWidget {
  final ThemeData initialTheme;
  final Widget child;

  const ThemeSwitcherWidget(
      {Key? key, required this.initialTheme, required this.child})
      : super(key: key);

  @override
  _ThemeSwitcherWidgetState createState() => _ThemeSwitcherWidgetState();
}

class _ThemeSwitcherWidgetState extends State<ThemeSwitcherWidget> {
  ThemeData? themeData;

  void switchTheme(ThemeData theme) {
    setState(() {
      themeData = theme;
    });
  }

  @override
  Widget build(BuildContext context) {
    themeData = themeData ?? widget.initialTheme;
    return ThemeSwitcher(
      data: this,
      child: widget.child,
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Project',
      theme: ThemeSwitcher.of(context).themeData,
      home: const FirstScreen(),
    );
  }
}
