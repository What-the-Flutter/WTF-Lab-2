import 'package:flutter/material.dart';
import 'task.dart';
import 'theme/custom_theme.dart';
import 'theme/app_theme.dart';

class InheritedMain extends InheritedWidget {
  final List<Task> tasks;

  @override
  final Widget child;

  const InheritedMain({Key? key,
    required this.child,
    required this.tasks,})
      : super(key: key, child: child);

  static InheritedMain? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<InheritedMain>();
  }

  @override
  bool updateShouldNotify(InheritedMain oldWidget) {
    return oldWidget.tasks != tasks;
  }
}
