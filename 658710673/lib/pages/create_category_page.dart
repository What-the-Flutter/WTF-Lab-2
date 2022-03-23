import 'package:flutter/material.dart';

import '../models/category.dart';
import '../utils/app_theme.dart';
import '../utils/constants.dart';

class CreateCategory extends StatefulWidget {
  CreateCategory(this._categories, this.editingIndex, {Key? key})
      : super(key: key);
  final int editingIndex;
  final List<Category> _categories;

  @override
  _CreateCategoryState createState() => _CreateCategoryState();
}

class _CreateCategoryState extends State<CreateCategory> {
  bool isWriting = false;
  final _textController = TextEditingController();
  int _selectedIconIndex = 0;

  @override
  void initState() {
    super.initState();
    if (widget.editingIndex != -1) {
      _textController.text = widget._categories[widget.editingIndex].title;
      _selectedIconIndex = CategoryIcons.icons
          .indexOf(widget._categories[widget.editingIndex].icon);
      isWriting = true;
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.fromLTRB(16, 50, 16, 16),
        child: Column(
          children: [
            Container(
              alignment: Alignment.center,
              child: Text(
                (widget.editingIndex == -1) ? 'Create a new page' : 'Edit page',
                style:
                    const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.fromLTRB(0, 16, 0, 0),
              child: TextField(
                controller: _textController,
                onChanged: (text) => setState(() {
                  isWriting = text.isEmpty ? false : true;
                }),
                maxLines: 1,
                decoration: InputDecoration(
                  hintText: 'Name of the page',
                  filled: true,
                  contentPadding: const EdgeInsets.all(10),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none),
                ),
              ),
            ),
            _iconsGridView(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        //backgroundColor: Constants.lPrimaryColor,
        child: isWriting
            ? const Icon(
                Icons.check,
                color: Colors.black,
              )
            : const Icon(
                Icons.close,
                color: Colors.black,
              ),
        onPressed: () => {
          if (isWriting)
            {
              if (widget.editingIndex == -1)
                {
                  widget._categories.add(
                    Category(
                      _textController.text,
                      CategoryIcons.icons[_selectedIconIndex],
                    ),
                  ),
                }
              else
                {
                  widget._categories[widget.editingIndex].title =
                      _textController.text,
                  widget._categories[widget.editingIndex].icon =
                      CategoryIcons.icons[_selectedIconIndex],
                }
            },
          Navigator.pop(context)
        },
      ),
    );
  }

  Expanded _iconsGridView() {
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
              backgroundColor: _selectedIconIndex != index
                  ? Colors.black12
                  : InheritedCustomTheme.of(context)
                      .themeData
                      .colorScheme
                      .primary,
              child: IconButton(
                onPressed: () => {
                  setState(() => _selectedIconIndex = index),
                },
                icon: CategoryIcons.icons[index],
              ),
            ),
          ),
        ),
        itemCount: CategoryIcons.icons.length,
      ),
    );
  }
}
