import 'package:flutter/material.dart';
import 'package:diploma/NewHome/EventHolder/Models/event_holder.dart';
import 'package:diploma/NewHome/Additional/theme_widget.dart';
import 'package:diploma/NewHome/EventHolder/Assets/eventholder_icons_set.dart';

enum EventHolderViewStates {
  adding,
  editing,
}

class AddEventHolderView extends StatefulWidget {
  final EventHolderViewStates state;
  final EventHolder? eventHolder;

  const AddEventHolderView(
    this.state, {
    this.eventHolder,
    Key? key,
  }) : super(key: key);

  @override
  State<AddEventHolderView> createState() => _AddEventHolderViewState();
}

class _AddEventHolderViewState extends State<AddEventHolderView> {
  late int _selectedIconIndex;
  late final TextEditingController _textController;
  late bool _emptyText;

  @override
  void initState() {
    super.initState();

    _selectedIconIndex = widget.state == EventHolderViewStates.adding
        ? 0
        : widget.eventHolder!.pictureIndex;

    _textController = TextEditingController(
        text: widget.state == EventHolderViewStates.adding
            ? ""
            : widget.eventHolder!.title);

    _emptyText = _textController.text.isEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: GeneralTheme.of(context).myTheme.themeData,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: creatingScaffold(),
      ),
    );
  }

  void _setSelectedIcon(int index) {
    assert(index >= 0 && index < setOfEventholderIcons.length);
    setState(() {
      _selectedIconIndex = index;
    });
  }

  void _checkText(String text) {
    setState(() {
      _emptyText = text.isEmpty;
    });
  }

  Scaffold creatingScaffold() {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.all(25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                'Create a new Page',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: TextField(
                controller: _textController,
                autofocus: false,
                decoration:
                    const InputDecoration(labelText: 'Name of the Page'),
                onChanged: (string) => _checkText(string),
              ),
            ),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 70,
                    childAspectRatio: 1,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20),
                itemCount: setOfEventholderIcons.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => _setSelectedIcon(index),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: index == _selectedIconIndex
                            ? Colors.lightGreen
                            : Colors.green,
                      ),
                      child: setOfEventholderIcons[index],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: _emptyText
          ? FloatingActionButton(
              onPressed: () => Navigator.pop(context, null),
              child: const Icon(Icons.cancel, color: Colors.black87),
              backgroundColor: Colors.yellow,
            )
          : FloatingActionButton(
              onPressed: () {
                switch (widget.state) {
                  case EventHolderViewStates.adding:
                    Navigator.pop(
                      context,
                      EventHolder(
                        events: [],
                        title: _textController.text,
                        pictureIndex: _selectedIconIndex,
                      ),
                    );
                    break;
                  case EventHolderViewStates.editing:
                    widget.eventHolder!.title = _textController.text;
                    widget.eventHolder!.pictureIndex = _selectedIconIndex;
                    Navigator.pop(
                      context,
                      widget.eventHolder!,
                    );
                    break;
                  default:
                    throw Exception("wrong state");
                }
              },
              child: const Icon(Icons.send, color: Colors.black87),
              backgroundColor: Colors.yellow,
            ),
    );
  }
}
