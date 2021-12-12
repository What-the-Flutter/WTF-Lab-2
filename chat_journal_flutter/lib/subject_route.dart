import 'package:flutter/material.dart';
import '../models/event.dart';

class EventList extends StatefulWidget {
  static const routeName = '/events_route';

  EventList({Key? key}) : super(key: key);

  @override
  _EventListState createState() => _EventListState();
}

class _EventListState extends State<EventList> {
  static const _acsentColor = Color(0xff86BB8B);
  final _textInputController = TextEditingController();

  final List<Event> _eventsList = [];
  late String _title;
  final Set<int> _selectedIndex = {};

  @override
  void dispose() {
    _textInputController.dispose();
    super.dispose();
  }

  void _addEvent() {
    var event = Event();
    event.content = _textInputController.text;
    _textInputController.clear();
    event.date = DateTime.now();
    _eventsList.add(event);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    _title = ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          _title,
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.amber[50]),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.favorite_outline),
          ),
        ],
      ),
      body: _routeBody,
      backgroundColor: Colors.blueGrey,
    );
  }

  Widget get _routeBody {
    return Column(
      children: <Widget>[
        _eventsList.isNotEmpty ? _messagesWidget : _noMessageWidget,
        Align(
          alignment: Alignment.bottomCenter,
          child: Row(
            children: <Widget>[
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.bubble_chart),
              ),
              Expanded(
                child: SizedBox(
                  child: TextField(
                    onSubmitted: (var stub) {
                      _addEvent();
                    },
                    controller: _textInputController,
                    style: const TextStyle(
                      fontSize: 20,
                    ),
                    decoration: const InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent)),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                      ),
                      hintText: 'Type your events',
                      fillColor: Color(0xffe5e5e5),
                      filled: true,
                    ),
                  ),
                ),
              ),
              IconButton(
                onPressed: _addEvent,
                icon: const Icon(Icons.send),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget get _messagesWidget {
    return Expanded(
      child: ListView.builder(
          shrinkWrap: true,
          padding: const EdgeInsets.only(top: 10, bottom: 10),
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  if (_selectedIndex.isNotEmpty) {
                    _selectedIndex.contains(index)
                        ? _selectedIndex.remove(index)
                        : _selectedIndex.add(index);
                  }
                });
              },
              onLongPress: () {
                setState(() {
                  _selectedIndex.add(index);
                  print(_selectedIndex);
                });
              },
              child: Container(
                padding: const EdgeInsets.only(
                    left: 14, right: 46, top: 10, bottom: 10),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: _selectedIndex.contains(index)
                            ? const Color(0xff507050)
                            : _acsentColor),
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      _eventsList[index].content,
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                ),
              ),
            );
          },
          itemCount: _eventsList.length),
    );
  }

  Widget get _noMessageWidget {
    return Expanded(
      child: Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: const EdgeInsets.only(top: 30),
          child: Container(
            decoration: BoxDecoration(
              color: _acsentColor.withOpacity(0.8),
              borderRadius: BorderRadius.circular(15),
            ),
            height: 300,
            width: 300,
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Text(
                  'This is page where you can track everything about "$_title" !',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                Padding(
                  child: Text(
                    "Add your first event to '$_title' page by entering some text in the textbox below and hitting the send button. Long tap the send button to align the event in the opposite direction. Tap on the bookmark icon on the top right corner to show the bookmarked events only.",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                      color: Color(0xff323232),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  padding: const EdgeInsets.only(top: 20),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
