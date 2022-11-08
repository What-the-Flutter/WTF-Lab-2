import 'package:flutter/cupertino.dart';

class FilterStateChanger extends StatefulWidget {
  final Widget child;

  const FilterStateChanger({Key? key, required this.child}) : super(key: key);

  @override
  State<FilterStateChanger> createState() => _FilterStateChangerState();
}

class _FilterStateChangerState extends State<FilterStateChanger> {
  bool isFiltered = false;
  String filter = '';
  void filterOn(){
    setState(() {
      isFiltered = true;
    });
  }
  void filterOff(){
    setState(() {
      isFiltered = false;
    });
  }
  @override
  Widget build(BuildContext context) {
    return FilterChanger(
      isFiltered: isFiltered,
      stateWidget: this,
      child: widget.child,
    );
  }
}

class FilterChanger extends InheritedWidget {
  final bool isFiltered;
  final _FilterStateChangerState stateWidget;

  const FilterChanger({
    super.key,
    required super.child,
    required this.isFiltered,
    required this.stateWidget,
  });

  static FilterChanger of(BuildContext context) {
    final result =
    context.dependOnInheritedWidgetOfExactType<FilterChanger>();
    assert(result != null, 'No context');
    return result!;
  }

  @override
  bool updateShouldNotify(FilterChanger oldWidget) => true;
}