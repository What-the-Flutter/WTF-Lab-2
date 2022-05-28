import 'package:flutter/material.dart';

import '../models/caregory.dart';
import '../models/core_state.dart';

class StateWidget extends StatefulWidget {
  final Widget child;

  const StateWidget({
    super.key,
    required this.child,
  });

  @override
  State<StateWidget> createState() => _StateWidgetState();
}

class _StateWidgetState extends State<StateWidget> {
  CoreState state = CoreState(
    isLightTheme: true,
    categories: <Category>[
      Category(
        title: 'Travel',
        icon: Icons.flight_takeoff,
      )..addEvent('I want to go to Crimea this summer', '16:23'),
      Category(
        title: 'Family',
        icon: Icons.chair,
      ),
      Category(
        title: 'Sport',
        icon: Icons.sports_football,
      ),
    ],
  );

  void swichTheme() {
    final isLightTheme = state.isLightTheme == true ? false : true;
    final newState = state.copyWith(isLightTheme: isLightTheme);

    setState(() => state = newState);
  }

  void addEvent(int index, String eventMessage, DateTime date) {
    state.categories[index]
        .addEvent(eventMessage, ('${date.hour}:${date.minute}'));

    final categories = state.categories;
    final newState = state.copyWith(categories: categories);

    setState(() => state = newState);
  }

  void addCategory(String title, IconData icon) {
    state.categories.add(Category(title: title, icon: icon));

    final categories = state.categories;
    final newState = state.copyWith(categories: categories);

    setState(() => state = newState);
  }

  void editCategory(String title, IconData icon, int index) {
    state.categories.removeAt(index);
    state.categories.insert(index, Category(title: title, icon: icon));

    final categories = state.categories;
    final newState = state.copyWith(categories: categories);

    setState(() => state = newState);
  }

  @override
  Widget build(BuildContext context) {
    return StateInheritedWidget(
      child: widget.child,
      state: state,
      stateWidget: this,
    );
  }
}

class StateInheritedWidget extends InheritedWidget {
  final CoreState state;
  final _StateWidgetState stateWidget;

  StateInheritedWidget({
    super.key,
    required super.child,
    required this.state,
    required this.stateWidget,
  });

  static _StateWidgetState of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<StateInheritedWidget>()!
        .stateWidget;
  }

  @override
  bool updateShouldNotify(StateInheritedWidget oldWidget) {
    return oldWidget.state != state;
  }
}
