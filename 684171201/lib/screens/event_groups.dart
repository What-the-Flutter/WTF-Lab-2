import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum States { viewMod, selectionMod, editingMod, chosensMod }

class EventsList extends StatefulWidget {
  final String title;

  const EventsList(this.title, {Key? key}) : super(key: key);

  @override
  _EventsListState createState() => _EventsListState();
}

class _EventsListState extends State<EventsList> {
  List<Event> listOfEvents = [];
  final _textFieldController = TextEditingController();
  bool _formIsEmpty = true;
  States _currentState = States.values[0];
  int _indexEditing = -1;
  int _numberOfPicked = 0;

  @override
  void initState() {
    super.initState();
    _textFieldController.addListener(() {
      setState(() {
        _textFieldController.text.isEmpty
            ? _formIsEmpty = true
            : _formIsEmpty = false;
      });
    });
  }

  @override
  void dispose() {
    _textFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_currentState == States.selectionMod && _numberOfPicked == 0) {
      _currentState = States.viewMod;
    }
    if (_currentState == States.viewMod) {
      for (var element in listOfEvents) {
        element.isPick = false;
      }
      _numberOfPicked = 0;
    }

    return Scaffold(
      appBar: _appBar(),
      body: Center(
        child: Column(
          children: [
            listOfEvents.isEmpty ? _caseEmptyistOfEvents() : const SizedBox(),
            _listOfEvents(),
            _inputForm(),
          ],
        ),
      ),
    );
  }

  Widget _inputForm() {
    return Row(
      children: [
        IconButton(
          onPressed: _currentState == States.selectionMod ? null : () {},
          icon: Icon(
            Icons.radar,
            color: !(_currentState == States.selectionMod)
                ? null
                : Colors.grey[600],
          ),
        ),
        Expanded(
          child: TextField(
            enabled: _currentState == States.selectionMod ? false : true,
            controller: _textFieldController,
            keyboardType: TextInputType.multiline,
            minLines: 1,
            maxLines: 5,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey[300],
              hintText: 'Enter smth',
            ),
          ),
        ),
        _fieldButton(),
      ],
    );
  }

  Widget _listOfEvents() {
    return Expanded(
      child: ListView.builder(
        itemCount: listOfEvents.length,
        itemBuilder: (context, index) {
          if (_currentState == States.chosensMod) {
            if (!listOfEvents[index].isChosen) {
              return const SizedBox();
            }
          }
          return Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 4.0, horizontal: 20.0),
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 300,
                ),
                child: GestureDetector(
                  onTap: _currentState == States.selectionMod
                      ? () {
                          setState(() {
                            if (listOfEvents[index].isPick == true) {
                              listOfEvents[index].isPick = false;
                              _numberOfPicked--;
                            } else {
                              listOfEvents[index].isPick = true;
                              _numberOfPicked++;
                            }
                          });
                        }
                      : () {
                          setState(() {
                            listOfEvents[index].isChosen == true
                                ? listOfEvents[index].isChosen = false
                                : listOfEvents[index].isChosen = true;
                          });
                        },
                  onLongPress: _currentState == States.viewMod
                      ? () {
                          setState(() {
                            listOfEvents[index].isPick = true;
                            _numberOfPicked++;
                            _currentState = States.selectionMod;
                          });
                        }
                      : null,
                  child: Container(
                    decoration: BoxDecoration(
                      color: listOfEvents[index].isPick == false
                          ? Colors.green[100]
                          : Colors.green[200],
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            listOfEvents[index].text,
                            style: const TextStyle(color: Colors.black),
                          ),
                          const SizedBox(
                            height: 2,
                          ),
                          SizedBox(
                            width: 70,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  '${listOfEvents[index].time.hour}:${listOfEvents[index].time.minute}',
                                  style: const TextStyle(color: Colors.grey),
                                ),
                                listOfEvents[index].isChosen
                                    ? const Icon(Icons.bookmark,
                                        color: Colors.yellow)
                                    : const SizedBox(),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _caseEmptyistOfEvents() {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.green[100],
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Column(
            children: [
              Center(
                child: Text(
                  'This is the page where you can track everything about ${widget.title}!\n',
                  style: const TextStyle(color: Colors.black, fontSize: 16),
                ),
              ),
              Center(
                child: Text(
                  'Add your first event to ${widget.title} page by entering some text in the text below and hitting the send button. Long tap the send button to allign the event in the opposite direction. Tap on the bookmark icon on the top right corner to show the bookbark events only.', 
                  style: const TextStyle(color: Colors.black38, fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconButton _fieldButton() {
    if (_formIsEmpty) {
      return IconButton(
        onPressed: _currentState == States.selectionMod ? null : () {},
        icon: Icon(
          Icons.camera,
          color:
              !(_currentState == States.selectionMod) ? null : Colors.grey[600],
        ),
      );
    } else {
      return IconButton(
        onPressed: _currentState == States.selectionMod
            ? null
            : _currentState == States.editingMod
                ? () {
                    setState(() {
                      listOfEvents[_indexEditing].text =
                          _textFieldController.text;
                      listOfEvents[_indexEditing].isPick = false;
                      _numberOfPicked = 0;
                      _indexEditing = -1;
                      _textFieldController.clear();
                      _currentState = States.viewMod;
                    });
                  }
                : () {
                    setState(
                      () {
                        listOfEvents.add(
                          Event(_textFieldController.text),
                        );
                        _textFieldController.clear();
                      },
                    );
                  },
        icon: Icon(
          Icons.send,
          color:
              !(_currentState == States.selectionMod) ? null : Colors.grey[600],
        ),
      );
    }
  }

  AppBar _appBar() {
    switch (_currentState) {
      case States.selectionMod:
        return AppBar(
          leading: IconButton(
            onPressed: () => setState(() {
              for (var item in listOfEvents) {
                item.isPick = false;
              }
              _numberOfPicked = 0;
            }),
            icon: const Icon(Icons.close),
          ),
          title: Text('$_numberOfPicked'),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.send_to_mobile),
            ),
            _numberOfPicked == 1
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        _currentState = States.editingMod;
                        _indexEditing = listOfEvents
                            .indexWhere((element) => element.isPick);
                        _textFieldController.text =
                            listOfEvents[_indexEditing].text;
                      });
                    },
                    icon: const Icon(Icons.edit),
                  )
                : const SizedBox(),
            IconButton(
              onPressed: () {
                setState(() {
                  Clipboard.setData(ClipboardData(text: _textAssembly()));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('text copied'),
                    ),
                  );
                  _currentState = States.viewMod;
                });
              },
              icon: const Icon(Icons.copy),
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  for (var element in listOfEvents) {
                    if (element.isPick) {
                      element.isChosen == true
                          ? element.isChosen = false
                          : element.isChosen = true;
                    }
                  }

                  _numberOfPicked = 0;
                });
              },
              icon: const Icon(Icons.bookmark_border),
            ),
            IconButton(
              onPressed: () {
                setState(
                  () {
                    showModalBottomSheet(
                      context: context,
                      builder: (builder) => SizedBox(
                        height: 200,
                        child: Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              const Padding(
                                padding: EdgeInsets.all(10.0),
                                child: Text(
                                  'Delete Events?',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(
                                  'Are you sure you want delete the $_numberOfPicked selected events?',
                                ),
                              ),
                              TextButton(
                                  child: Row(
                                    children: const [
                                      Icon(Icons.delete, color: Colors.red),
                                      SizedBox(
                                        width: 15,
                                      ),
                                      Text('Delete')
                                    ],
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      listOfEvents.removeWhere(
                                          (element) => element.isPick == true);
                                      _numberOfPicked = 0;
                                      Navigator.pop(context);
                                    });
                                  }),
                              TextButton(
                                  child: Row(
                                    children: const [
                                      Icon(Icons.cancel_rounded,
                                          color: Colors.blue),
                                      SizedBox(
                                        width: 15,
                                      ),
                                      Text('Cancel')
                                    ],
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  })
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
              icon: const Icon(Icons.delete),
            ),
          ],
        );
      case States.editingMod:
        return AppBar(
          leading: IconButton(
            onPressed: () {
              setState(() {
                _currentState = States.viewMod;
                listOfEvents[_indexEditing].isPick = false;
                _numberOfPicked = 0;
              });
            },
            icon: const Icon(Icons.close),
          ),
          title: const Text('Editing mode'),
          centerTitle: true,
        );
      default:
        return AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back),
          ),
          title: Text(widget.title),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.search),
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  _currentState == States.chosensMod
                      ? _currentState = States.viewMod
                      : _currentState = States.chosensMod;
                });
              },
              icon: _currentState == States.chosensMod
                  ? const Icon(Icons.bookmark, color: Colors.yellow)
                  : const Icon(Icons.bookmark_border),
            ),
          ],
        );
    }
  }

  String _textAssembly() {
    var assembledText = '';
    for (var element in listOfEvents) {
      if (element.isPick == true) {
        assembledText += element.text;
        assembledText += '\n';
      }
    }
    return assembledText;
  }
}

class Event {
  Event(this.text) : time = DateTime.now();
  late final DateTime time;
  bool isPick = false;
  bool isChosen = false;
  String text;
}
