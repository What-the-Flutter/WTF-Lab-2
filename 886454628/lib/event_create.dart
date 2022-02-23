import 'package:flutter/material.dart';

import 'data.dart';

class EventCreate extends StatefulWidget {
  EventCreate(this.pages, editingIndex, {Key? key}) : super(key: key);
  final List<MyPage> pages;
  final int editingIndex = -1;

  @override
  State<EventCreate> createState() => _EventCreateState();
}

class _EventCreateState extends State<EventCreate> {
  int _currentIndex = 0;
  bool isWriting = false;
  final _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    if (widget.editingIndex != -1) {
      _textController.text = widget.pages[widget.editingIndex].text;
      _currentIndex = icons.indexOf(widget.pages[widget.editingIndex].icon);
      isWriting = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.fromLTRB(10, 40, 10, 10),
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Container(
              alignment: Alignment.center,
              child: const Text(
                'Create a new Page\n',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
            ),
            Center(
              child: TextField(
                controller: _textController,
                onChanged: (value) => setState(
                  () {
                    isWriting = value.isEmpty ? false : true;
                  },
                ),
                maxLines: 1,
                decoration: const InputDecoration(
                  hintText: 'Name of the page',
                  filled: true,
                ),
              ),
            ),
            iconsGridView(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: isWriting
            ? const Icon(
                Icons.check,
                color: Colors.black,
              )
            : const Icon(
                Icons.close,
                color: Colors.black,
              ),
        backgroundColor: Colors.yellow,
        onPressed: () => {
          if (isWriting)
            {
              if (widget.editingIndex == -1)
                {
                  widget.pages.add(
                    MyPage(
                      _textController.text,
                      icons[_currentIndex],
                    ),
                  ),
                }
              else
                {
                  widget.pages[widget.editingIndex].text = _textController.text,
                  widget.pages[widget.editingIndex].icon = icons[_currentIndex],
                }
            },
          Navigator.pop(context)
        },
      ),
    );
  }

  Expanded iconsGridView() {
    return Expanded(
      child: GridView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.all(8.0),
          child: GridTile(
            child: CircleAvatar(
              backgroundColor:
                  _currentIndex != index ? Colors.blueGrey : Colors.lime,
              child: IconButton(
                onPressed: () => {
                  setState(() => _currentIndex = index),
                },
                icon: icons[index],
              ),
            ),
          ),
        ),
        itemCount: icons.length,
      ),
    );
  }
}
