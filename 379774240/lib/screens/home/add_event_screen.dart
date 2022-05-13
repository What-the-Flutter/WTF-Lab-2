import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';
import '../../models/category.dart';

class AddEvent extends StatefulWidget {
  final Category category;
  const AddEvent({
    Key? key,
    required this.category,
  }) : super(key: key);

  @override
  State<AddEvent> createState() => _AddEventState();
}

class _AddEventState extends State<AddEvent> {
  final _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopBar(context),
      body: Body(
        category: widget.category,
        textEditingController: _textEditingController,
      ),
    );
  }

  AppBar TopBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      shadowColor: Colors.transparent,
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: const Icon(
          Icons.arrow_back,
          color: AppColors.textColor,
        ),
      ),
      title: Text(widget.category.name, style: AppFonts.headerTextStyle),
      centerTitle: true,
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.search,
            color: AppColors.textColor,
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.favorite_outline,
            color: AppColors.textColor,
          ),
        ),
      ],
    );
  }
}

class Body extends StatelessWidget {
  const Body({
    Key? key,
    required this.category,
    required this.textEditingController,
  }) : super(key: key);

  final Category category;
  final TextEditingController textEditingController;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Divider(),
        MessageList(category: category),
        BottomBar(
          category: category,
          textEditingController: textEditingController,
        ),
      ],
    );
  }
}

class BottomBar extends StatefulWidget {
  BottomBar({
    Key? key,
    required this.category,
    required this.textEditingController,
  }) : super(key: key);

  final Category category;
  final TextEditingController textEditingController;

  @override
  State<BottomBar> createState() => _BottomBarState(
        textEditingController: textEditingController,
      );
}

class _BottomBarState extends State<BottomBar> {
  final TextEditingController textEditingController;

  _BottomBarState({
    required this.textEditingController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      decoration: const BoxDecoration(color: AppColors.primaryColor),
      child: SafeArea(
        child: Row(
          children: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.attachment),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: TextField(
                  onSubmitted: ((value) {
                    setState(() {
                      if (textEditingController.text != '') {
                        widget.category.addMessage(
                            textEditingController.text, DateTime.now());
                        textEditingController.clear();
                      }
                    });
                  }),
                  controller: textEditingController,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Type note',
                    hintStyle: AppFonts.defaultTextStyle,
                  ),
                ),
              ),
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  if (textEditingController.text != '') {
                    widget.category
                        .addMessage(textEditingController.text, DateTime.now());
                    textEditingController.clear();
                  }
                });
              },
              icon: const Icon(
                Icons.send,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class MessageList extends StatelessWidget {
  const MessageList({
    Key? key,
    required this.category,
  }) : super(key: key);

  final Category category;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        dragStartBehavior: DragStartBehavior.down,
        itemCount: category.messages.length,
        itemBuilder: (context, index) => Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              constraints: const BoxConstraints(maxWidth: 350),
              decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  borderRadius: BorderRadius.circular(40)),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: SelectableText(category.messages[index].messageText,
                  style: const TextStyle(fontSize: 14)),
            )
          ],
        ),
      ),
    );
  }
}
