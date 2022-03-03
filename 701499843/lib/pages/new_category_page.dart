import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../icons.dart';
import '../models/event_icon.dart';

class NewCategoryPage extends StatefulWidget {
  NewCategoryPage({
    Key? key,
    this.title = '',
    this.icon,
  }) : super(key: key);

  final String title;
  late final Icon? icon;
  NewCategoryPage.edit({
    Key? key,
    required this.title,
    required this.icon,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _NewCategoryPageState();
}

class _NewCategoryPageState extends State<NewCategoryPage> {
  final List<EventIcon> iconsList = <EventIcon>[];
  bool _writingMode = false;
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (iconsList.isEmpty) iconsList.addAll(icons(context));
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text('Create a new Page'),
        centerTitle: true,
      ),
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(40),
        child: Column(
          children: [
            TextField(
              onChanged: (text) {
                setState(() {
                  _writingMode = text.isNotEmpty;
                });
              },
              keyboardType: TextInputType.multiline,
              decoration: InputDecoration(
                labelText: widget.title != ''
                    ? '''Previous title: ${widget.title} 
Please, enter new value'''
                    : null,
                hintText: 'Name of the Page',
                hintStyle: TextStyle(
                  color: Theme.of(context).hintColor,
                ),
                filled: true,
                border: InputBorder.none,
              ),
              minLines: 5,
              maxLines: 10,
              controller: _controller,
            ),
            _iconsGrid(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {
          if (_controller.text.isNotEmpty &&
              iconsList
                  .where((element) => element.isSelected == true)
                  .isNotEmpty)
            {
              Navigator.pop(
                context,
                {
                  _controller.text: iconsList
                      .where((element) => element.isSelected == true)
                      .first
                      .icon,
                },
              ),
            },
        },
        child: Icon(
          Icons.check,
          color: Theme.of(context).scaffoldBackgroundColor,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Expanded _iconsGrid() {
    return Expanded(
      child: GridView.builder(
        itemCount: iconsList.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: kIsWeb ? 10 : 4,
          mainAxisSpacing: kIsWeb ? 25 : 5,
          crossAxisSpacing: kIsWeb ? 90 : 5,
        ),
        padding: const EdgeInsets.fromLTRB(0, 45, 0, 0),
        itemBuilder: (context, index) {
          return Stack(
            children: [
              CircleAvatar(
                backgroundColor: Theme.of(context).colorScheme.secondary,
                child: IconButton(
                  icon: iconsList[index].icon,
                  onPressed: () => setState(() {
                    {
                      iconsList.clear();
                      iconsList.addAll(icons(context));
                    }
                    iconsList[index] = iconsList[index].copyWith(
                      isSelected: true,
                      icon: Icon(
                        iconsList[index].icon.icon,
                        color: Theme.of(context).hintColor,
                      ),
                    );
                  }),
                  iconSize: 25,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
