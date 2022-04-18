import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../widgets/app_bar_button.dart';
import '../widgets/input_event_bar.dart';


class EventScreen extends StatefulWidget {
  EventScreen({Key? key}) : super(key: key);

  @override
  State<EventScreen> createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  List<String> eventList = <String>[
    'Play footbal',
    'Read book',
  ];

  final _controller = TextEditingController();
  final _editController = TextEditingController();
  bool enableOptions = false;
  late int _selectedIndex;
  
  void changeOptions() => setState(() => enableOptions = !enableOptions);

  void _addEvent() {
    setState(() {
      eventList.add(_controller.text);
      _controller.clear();
    });
  }

  int selectedIndex(String str) {
    var index = 0;

    while (!(str == eventList[index])) {
      index++;
    }

    _selectedIndex = index;
    return index;
  }

  Future<void> editEvent(int index) async {
    _editController.text = eventList[index];

    return showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('AlertDialog Title'),
        content: TextField(
          controller: _editController,
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context, 'OK');
              setState(() => eventList[index] = _editController.text);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void deleteEvent(int index) => setState(() => eventList.removeAt(index));

  void copyEvent(int index) {
    Clipboard.setData(ClipboardData(text: eventList[index])).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Your text copied to clipboard')));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: enableOptions
            ? AppBarButton(Icons.close, changeOptions)
            : AppBarButton(Icons.arrow_back, () => Navigator.pop(context)),
        title: enableOptions ? const Text('') : const Text('Travel'),
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
                    children: (eventList.map((event) {
                      return GestureDetector(
                        onLongPress: () => setState(() {
                          enableOptions = true;
                          selectedIndex(event);
                        }),
                        child: Container(
                          key: UniqueKey(),
                          padding: const EdgeInsets.all(10.0),
                          margin: const EdgeInsets.symmetric(
                            vertical: 5.0,
                            horizontal: 5.0,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.lime[400],
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Text(
                            event,
                          ),
                        ),
                      );
                    }).toList()),
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
