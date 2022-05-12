import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../widgets/app_bar_button.dart';
import '../widgets/input_event_bar.dart';

class EventScreen extends StatefulWidget {
  final String title;
  final List<String> events;

  EventScreen({required this.title, required this.events, Key? key})
      : super(key: key);

  @override
  State<EventScreen> createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  final _controller = TextEditingController();
  final _editController = TextEditingController();
  bool enableOptions = false;
  late int _selectedIndex;

  void changeOptions() => setState(() => enableOptions = !enableOptions);

  void _addEvent() {
    setState(
      () {
        widget.events.add(_controller.text);
        _controller.clear();
      },
    );
  }

  int selectedIndex(String str) {
    var index = 0;

    while (!(str == widget.events[index])) {
      index++;
    }

    _selectedIndex = index;
    return index;
  }

  Future<void> editEvent(int index) async {
    _editController.text = widget.events[index];

    return showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit'),
        content: TextField(
          controller: _editController,
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() => enableOptions = false);
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(
                () {
                  widget.events[index] = _editController.text;
                  enableOptions = false;
                },
              );
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void deleteEvent(int index) {
    setState(
      () {
        widget.events.removeAt(index);
        enableOptions = false;
      },
    );
  }

  void copyEvent(int index) {
    Clipboard.setData(ClipboardData(text: widget.events[index])).then(
      (_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Your text copied to clipboard'),
          ),
        );
      },
    );
    setState(() => enableOptions = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: enableOptions
            ? AppBarButton(Icons.close, changeOptions)
            : AppBarButton(Icons.arrow_back, () => Navigator.pop(context)),
        title: enableOptions ? const Text('') : Text(widget.title),
        centerTitle: true,
        actions: enableOptions
            ? [
                AppBarButton(Icons.edit, () => editEvent(_selectedIndex)),
                AppBarButton(Icons.delete, () => deleteEvent(_selectedIndex)),
                AppBarButton(Icons.copy, () => copyEvent(_selectedIndex)),
              ]
            : [
                AppBarButton(Icons.search, () => {}),
                AppBarButton(Icons.bookmark, () => {}),
              ],
      ),
      body: Column(
        children: [
          Expanded(
            flex: 5,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: SingleChildScrollView(
                clipBehavior: Clip.hardEdge,
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: widget.events.map(
                      (event) {
                        return GestureDetector(
                          onLongPress: () => setState(
                            () {
                              enableOptions = true;
                              selectedIndex(
                                event,
                              );
                            },
                          ),
                          child: Container(
                            key: UniqueKey(),
                            padding: const EdgeInsets.all(10.0),
                            margin: const EdgeInsets.symmetric(
                              vertical: 5.0,
                              horizontal: 5.0,
                            ),
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Text(
                              event,
                              style: Theme.of(context).primaryTextTheme.bodyText1,
                            ),
                          ),
                        );
                      },
                    ).toList(),
                  ),
                ),
              ),
            ),
          ),
          InputEventBar(addEvent: _addEvent, controller: _controller),
        ],
      ),
    );
  }
}
