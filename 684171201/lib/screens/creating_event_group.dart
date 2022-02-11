import 'package:flutter/material.dart';

import '../main.dart';

import 'home_screen.dart';

enum MyState { creatingMod, editingMod }

class CreatingPage extends StatefulWidget {
  const CreatingPage({Key? key, this.chosenPage}) : super(key: key);
  final int? chosenPage;

  @override
  _CreatingPageState createState() => _CreatingPageState();
}

class _CreatingPageState extends State<CreatingPage> {
  int chosenIndex = -1;
  MyState currentState = MyState.values[0];
  final _formController = TextEditingController();
  bool _formIsEmpty = true;
  bool isNotCorrectData = true;
  @override
  void initState() {
    super.initState();
    if (widget.chosenPage != null) {
      currentState = MyState.values[1];
      _formController.text = eventGroups[widget.chosenPage as int].text;
      chosenIndex = eventGroups[widget.chosenPage as int].iconIndex;
    }
    _formController.addListener(() {
      setState(() {
        _formController.text.isEmpty
            ? _formIsEmpty = true
            : _formIsEmpty = false;
      });
    });
  }



  Scaffold creatingScaffold() {
    switch (currentState) {
      case MyState.editingMod:
        return Scaffold(
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Create a new Page',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: TextField(
                    controller: _formController,
                    autofocus: true,
                    decoration: const InputDecoration(labelText: 'Name of the Page'),
                  ),
                ),
                Expanded(
                  child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 70,
                              childAspectRatio: 1,
                              crossAxisSpacing: 20,
                              mainAxisSpacing: 20),
                      itemCount: availableIcons.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              chosenIndex = index;
                            });
                          },
                          child: Container(
                            height: 70,
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: index == chosenIndex
                                    ? Colors.green
                                    : Colors.grey),
                            child: availableIcons[index],
                          ),
                        );
                      }),
                ),
              ],
            ),
          ),
          floatingActionButton: isNotCorrectData
              ? FloatingActionButton(
                  onPressed: () {
                    setState(() {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                          builder: (context) => const FirstScreen(),
                        ),
                      );
                    });
                  },
                  child: const Icon(Icons.close, color: Colors.black87),
                  backgroundColor: Colors.yellow,
                )
              : FloatingActionButton(
                  onPressed: () {
                    setState(() {
                      eventGroups[widget.chosenPage as int] =
                          EventGroup(chosenIndex, _formController.text);
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                          builder: (context) => const FirstScreen(),
                        ),
                      );
                    });
                  },
                  child: const Icon(Icons.send, color: Colors.black87),
                  backgroundColor: Colors.yellow,
                ),
        );
      default:
        return Scaffold(
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Create a new Page',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: TextField(
                    controller: _formController,
                    autofocus: true,
                    decoration: const InputDecoration(labelText: 'Name of the Page'),
                  ),
                ),
                Expanded(
                  child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 70,
                              childAspectRatio: 1,
                              crossAxisSpacing: 20,
                              mainAxisSpacing: 20),
                      itemCount: availableIcons.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              chosenIndex = index;
                            });
                          },
                          child: Container(
                            height: 70,
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: index == chosenIndex
                                    ? Colors.green
                                    : Colors.grey),
                            child: availableIcons[index],
                          ),
                        );
                      }),
                ),
              ],
            ),
          ),
          floatingActionButton: isNotCorrectData
              ? FloatingActionButton(
                  onPressed: () {
                    setState(() {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                          builder: (context) => const FirstScreen(),
                        ),
                      );
                    });
                  },
                  child: const Icon(Icons.close, color: Colors.black87),
                  backgroundColor: Colors.yellow,
                )
              : FloatingActionButton(
                  onPressed: () {
                    setState(() {
                      eventGroups
                          .add(EventGroup(chosenIndex, _formController.text));
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                          builder: (context) => const FirstScreen(),
                        ),
                      );
                    });
                  },
                  child: const Icon(Icons.send, color: Colors.black87),
                  backgroundColor: Colors.yellow,
                ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_formIsEmpty || chosenIndex == -1) {
      isNotCorrectData = true;
    } else {
      isNotCorrectData = false;
    }
    if (widget.chosenPage != null) {
      currentState = MyState.values[1];
    }
    return creatingScaffold();
  }
}
