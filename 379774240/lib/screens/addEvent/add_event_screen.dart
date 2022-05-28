import 'package:flutter/material.dart';

import '../../constants.dart';
import '../../inherited/app_state.dart';

class AddEventScreen extends StatefulWidget {
  final int categoryIndex;

  AddEventScreen({
    super.key,
    required this.categoryIndex,
  });

  @override
  State<AddEventScreen> createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final category =
        StateInheritedWidget.of(context).state.categories[widget.categoryIndex];

    return Scaffold(
      appBar: buildAppBar(context, category.title),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: category.events.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(
                    0,
                    kDefaultPadding,
                    kDefaultPadding / 2,
                    0,
                  ),
                  child: Row(
                    key: UniqueKey(),
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        category.events[index].date,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                      ),
                      const SizedBox(
                        width: kDefaultPadding / 2,
                      ),
                      Container(
                        constraints: const BoxConstraints(maxWidth: 300),
                        padding: const EdgeInsets.symmetric(
                          vertical: kDefaultPadding * 0.75,
                          horizontal: kDefaultPadding * 1.25,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: SelectableText(
                          category.events[index].message,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.background,
            ),
            padding: const EdgeInsets.symmetric(
              vertical: kDefaultPadding / 2,
              horizontal: kDefaultPadding / 2,
            ),
            child: SafeArea(
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.attachment,
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: kDefaultPadding,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: TextField(
                        onSubmitted: (value) {
                          if (_controller.text != '') {
                            setState(() {
                              addEvent(widget.categoryIndex, _controller.text,
                                  DateTime.now());
                              _controller.clear();
                            });
                          }
                        },
                        controller: _controller,
                        decoration: const InputDecoration(
                          hintText: 'Type message',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      if (_controller.text != '') {
                        setState(() {
                          addEvent(widget.categoryIndex, _controller.text,
                              DateTime.now());
                          _controller.clear();
                        });
                      }
                    },
                    icon: Icon(
                      Icons.send,
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  AppBar buildAppBar(BuildContext context, String title) {
    return AppBar(
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: Icon(
          Icons.arrow_back,
          color: Theme.of(context).colorScheme.onPrimary,
        ),
      ),
      title: Text(title),
      actions: [
        IconButton(
          onPressed: () {},
          icon: Icon(
            Icons.search,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: Icon(
            Icons.favorite_outline,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
      ],
    );
  }

  void addEvent(int index, String eventMessage, DateTime date) {
    final provider = StateInheritedWidget.of(context);
    provider.addEvent(index, eventMessage, date);
  }
}
