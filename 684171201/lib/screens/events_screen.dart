import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';

enum MyState { viewMod, selectionMod, editingMod, chosensMod }

class EventsList extends StatefulWidget {
  const EventsList(this.title, {Key? key}) : super(key: key);
  final String title;

  @override
  _EventsListState createState() => _EventsListState();
}

class _EventsListState extends State<EventsList> {
  List<Event> listOfEvents = [];
  final _textFieldController = TextEditingController();
  var _formIsEmpty = true;
  var currentState = MyState.values[0];
  var indexEditing = -1;
  var numberOfPicked = 0;

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

  void stateSetter() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (currentState == MyState.selectionMod) {
      numberOfPicked == 0 ? currentState = MyState.viewMod : null;
    }
    if (currentState == MyState.viewMod) {
      listOfEvents.forEach((element) {
        element.isPick = false;
      });
      numberOfPicked = 0;
    }
    return Scaffold(
      appBar: _appBar(),
      body: Center(
        child: Column(
          children: [
            listOfEvents.isEmpty
                ? Center(
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
                                "This is the page where you can track everything about ${widget.title}!\n",
                                style: const TextStyle(
                                    color: Colors.black, fontSize: 16),
                              ),
                            ),
                            Center(
                              child: Text(
                                "Add your first event to ${widget.title} page by entering some text in the text below and hitting the send button. Long tap the send button to allign the event in the opposite direction. Tap on the bookmark icon on the top right corner to show the bookbark events only.",
                                style: const TextStyle(
                                    color: Colors.black38, fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                : const SizedBox(),
            Expanded(
              child: ListView.builder(
                itemCount: listOfEvents.length,
                itemBuilder: (context, index) {
                  if (currentState == MyState.chosensMod) {
                    if (!listOfEvents[index].isChosen) {
                      return const SizedBox();
                    }
                  }
                  return Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 4.0, horizontal: 20.0),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxWidth: 300,
                        ),
                        child: GestureDetector(
                          onTap: currentState == MyState.selectionMod
                              ? () {
                                  setState(() {
                                    if (listOfEvents[index].isPick == true) {
                                      listOfEvents[index].isPick = false;
                                      numberOfPicked--;
                                    } else {
                                      listOfEvents[index].isPick = true;
                                      numberOfPicked++;
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
                          onLongPress: currentState == MyState.viewMod
                              ? () {
                                  setState(() {
                                    listOfEvents[index].isPick = true;
                                    numberOfPicked++;
                                    currentState = MyState.selectionMod;
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
                              padding: EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    listOfEvents[index].text,
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  const SizedBox(
                                    height: 2,
                                  ),
                                  SizedBox(
                                    width: 70,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${listOfEvents[index].time.hour}:${listOfEvents[index].time.minute}",
                                          style: const TextStyle(
                                              color: Colors.grey),
                                        ),
                                        listOfEvents[index].isChosen
                                            ? const Icon(Icons.bookmark,
                                                color: Colors.yellow)
                                            : SizedBox(),
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
            ),
            Row(
              children: [
                IconButton(
                  onPressed:
                      currentState == MyState.selectionMod ? null : () {},
                  icon: Icon(
                    Icons.radar,
                    color: !(currentState == MyState.selectionMod)
                        ? null
                        : Colors.grey[600],
                  ),
                ),
                Expanded(
                  child: TextField(
                    enabled:
                        currentState == MyState.selectionMod ? false : true,
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
            ),
          ],
        ),
      ),
    );
  }

  IconButton _fieldButton() {
    if (_formIsEmpty) {
      return IconButton(
        onPressed: currentState == MyState.selectionMod ? null : () {},
        icon: Icon(
          Icons.camera,
          color:
              !(currentState == MyState.selectionMod) ? null : Colors.grey[600],
        ),
      );
    } else {
      return IconButton(
        onPressed: currentState == MyState.selectionMod
            ? null
            : currentState == MyState.editingMod
                ? () {
                    setState(
                      () {
                        listOfEvents[indexEditing].text =
                            _textFieldController.text;
                        listOfEvents[indexEditing].isPick = false;
                        numberOfPicked = 0;
                        indexEditing = -1;
                        _textFieldController.clear();
                        currentState = MyState.viewMod;
                      },
                    );
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
              !(currentState == MyState.selectionMod) ? null : Colors.grey[600],
        ),
      );
    }
  }

  AppBar _appBar() {
    switch (currentState) {
      case MyState.selectionMod:
        return AppBar(
          leading: IconButton(
            onPressed: () {
              setState(() {
                for (var item in listOfEvents) {
                  item.isPick = false;
                }
                numberOfPicked = 0;
              });
            },
            icon: const Icon(Icons.close),
          ),
          title: Text("$numberOfPicked"),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.send_to_mobile),
            ),
            numberOfPicked == 1
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        currentState = MyState.editingMod;
                        indexEditing = listOfEvents
                            .indexWhere((element) => element.isPick);
                        _textFieldController.text =
                            listOfEvents[indexEditing].text;
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
                  currentState = MyState.viewMod;
                });
              },
              icon: const Icon(Icons.copy),
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  listOfEvents.forEach((element) {
                    if (element.isPick) {
                      element.isChosen == true
                          ? element.isChosen = false
                          : element.isChosen = true;
                    }
                  });
                  numberOfPicked = 0;
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
                      builder: (builder) => Container(
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
                                  'Are you sure you want delete the $numberOfPicked selected events?',
                                ),
                              ),
                              TextButton(
                                  child: Row(
                                    children: const [
                                      Icon(Icons.delete, color: Colors.red),
                                      SizedBox(
                                        width: 15,
                                      ),
                                      Text("Delete")
                                    ],
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      listOfEvents.removeWhere(
                                          (element) => element.isPick == true);
                                      numberOfPicked = 0;
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
                                      Text("Cancel")
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
      case MyState.editingMod:
        return AppBar(
          leading: IconButton(
            onPressed: () {
              setState(() {
                currentState = MyState.viewMod;
                listOfEvents[indexEditing].isPick = false;
                numberOfPicked = 0;
              });
              ;
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
                  currentState == MyState.chosensMod
                      ? currentState = MyState.viewMod
                      : currentState = MyState.chosensMod;
                });
              },
              icon: currentState == MyState.chosensMod
                  ? const Icon(Icons.bookmark, color: Colors.yellow)
                  : const Icon(Icons.bookmark_border),
            ),
          ],
        );
    }
  }

  String _textAssembly() {
    String assembledText = '';
    listOfEvents.forEach((element) {
      if (element.isPick == true) {
        assembledText += element.text;
        assembledText += '\n';
      }
    });
    return assembledText;
  }
}

class Event {
  Event(this.text) : time = DateTime.now();
  bool isPick = false;
  bool isChosen = false;
  String text;
  late final DateTime time;
}
