import 'package:flutter/material.dart';

import 'package:diploma/models/event_holder.dart';
import 'package:diploma/eventholder_icons_set.dart';

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
  late bool _emptyText;
  late final TextEditingController _textController;

  @override
  void initState() {
    super.initState();

    _selectedIconIndex = widget.state == EventHolderViewStates.adding
        ? 0
        : widget.eventHolder!.iconIndex;

    _textController = TextEditingController(
        text: widget.state == EventHolderViewStates.adding
            ? ""
            : widget.eventHolder!.title);

    _emptyText = _textController.text.isEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: _body(),
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

  Scaffold _body() {
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
              child: _iconsGrid(),
            ),
          ],
        ),
      ),
      floatingActionButton: _floatingActionButton(),
    );
  }

  Widget _iconsGrid() {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 70,
        childAspectRatio: 1,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
      ),
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
    );
  }

  FloatingActionButton _floatingActionButton() {
    return _emptyText
        ? FloatingActionButton(
            onPressed: () => Navigator.pop(context),
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
                      title: _textController.text,
                      iconIndex: _selectedIconIndex,
                    ),
                  );
                  break;
                case EventHolderViewStates.editing:
                  Navigator.pop(
                    context,
                    widget.eventHolder!.copyWith(
                      title: _textController.text,
                      iconIndex: _selectedIconIndex,
                    ),
                  );
                  break;
                default:
                  throw Exception("wrong state");
              }
            },
            child: const Icon(Icons.send, color: Colors.black87),
            backgroundColor: Colors.yellow,
          );
  }
}
