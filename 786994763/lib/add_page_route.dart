import 'package:flutter/material.dart';

import 'models/adding_page.dart';
import 'models/page.dart';
import 'styles.dart';

class PageInput extends StatefulWidget {
  static const routeName = '/add_page_route';
  PageInput({Key? key}) : super(key: key);

  @override
  _PageInputState createState() => _PageInputState();
}

class _PageInputState extends State<PageInput> {
  final List<NewPage> _pageIcons = [];
  final _titlePageController = TextEditingController();
  late var _pagesList = [];
  final _pageSubtitleText = 'No Events. Click to create one.';

  @override
  Widget build(BuildContext context) {
    _pagesList = ModalRoute.of(context)!.settings.arguments as List<PageInfo>;
    if (_pageIcons.isEmpty) {
      _pageIcons.add(NewPage.selected(const Icon(Icons.cake), true));
      _pageIcons.add(NewPage(const Icon(Icons.chair)));
      _pageIcons.add(NewPage(const Icon(Icons.build)));
      _pageIcons.add(NewPage(const Icon(Icons.pets)));
      _pageIcons.add(NewPage(const Icon(Icons.ramen_dining)));
      _pageIcons.add(NewPage(const Icon(Icons.fastfood)));
      _pageIcons.add(NewPage(const Icon(Icons.wine_bar)));
      _pageIcons.add(NewPage(const Icon(Icons.shopping_cart)));
      _pageIcons.add(NewPage(const Icon(Icons.music_note)));
      _pageIcons.add(NewPage(const Icon(Icons.account_balance_wallet)));
      _pageIcons.add(NewPage(const Icon(Icons.coffee)));
      _pageIcons.add(NewPage(const Icon(Icons.medication)));
      _pageIcons.add(NewPage(const Icon(Icons.call_end)));
      _pageIcons.add(NewPage(const Icon(Icons.attach_money_outlined)));
      _pageIcons.add(NewPage(const Icon(Icons.radio)));
      _pageIcons.add(NewPage(const Icon(Icons.voice_chat)));
      _pageIcons.add(NewPage(const Icon(Icons.flight)));
      _pageIcons.add(NewPage(const Icon(Icons.smoking_rooms)));
      _pageIcons.add(NewPage(const Icon(Icons.brush)));
      _pageIcons.add(NewPage(const Icon(Icons.pedal_bike)));
    }

    return MaterialApp(
      home: _homeWidget,
      theme: ThemeData(primarySwatch: Colors.indigo),
    );
  }

  void _clearSelectionIcons() {
    for (var item in _pageIcons) {
      item.isSelected = false;
    }
  }

  void _selectPageIcon(int index) {
    _clearSelectionIcons();
    _pageIcons[index].isSelected = true;

    setState(() {});
  }

  Icon get _selectedPageIcon {
    for (var item in _pageIcons) {
      if (item.isSelected) return item.icon;
    }
    return _pageIcons.first.icon;
  }

  void _addNewPage() {
    _pagesList.add(PageInfo(_titlePageController.text, _selectedPageIcon,
        DateTime.now(), DateTime.now()));
    Navigator.pop(context, _pagesList);
  }

  Widget get _homeWidget {
    return Scaffold(
      body: _titleBody,
      floatingActionButton: _titlePageController.text.isEmpty
          ? _buttonCancelAddingPage
          : _buttonAddPage,
    );
  }

  Widget get _titleBody {
    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
          padding: const EdgeInsets.only(
            top: 80,
          ),
          child: Column(
            children: [
              const Text(
                'Create a new Page',
                style: categoryTitleStyle,
              ),
              _textFiled,
              _gridViewIcons,
            ],
          )),
    );
  }

  Widget get _textFiled {
    return Container(
      width: 320,
      padding: const EdgeInsets.only(top: 20),
      child: TextField(
        onChanged: (var stub) {
          setState(() {});
        },
        controller: _titlePageController,
        style: categoryTitleStyle,
        decoration: InputDecoration(
          labelText: 'Input new page name',
          labelStyle: pageInputHintStyle,
          errorStyle: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            foreground: Paint()..color = Colors.white,
            background: Paint()..color = Colors.red,
          ),
          enabledBorder: borderStyle,
          focusedBorder: borderStyle,
          fillColor: Colors.blueGrey,
          filled: true,
        ),
      ),
    );
  }

  Widget get _gridViewIcons {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(
          right: 20,
          left: 20,
        ),
        child: GridView.count(
          crossAxisCount: 4,
          children: List.generate(_pageIcons.length, (index) {
            return UnconstrainedBox(
              child: Stack(
                children: [
                  Container(
                    height: 70,
                    width: 70,
                    decoration: BoxDecoration(
                      color: Colors.indigo,
                      borderRadius: BorderRadius.circular(35),
                    ),
                    child: IconButton(
                      iconSize: 36,
                      icon: _pageIcons[index].icon,
                      color: Colors.white,
                      onPressed: () => _selectPageIcon(index),
                    ),
                  ),
                  _pageIcons[index].isSelected ? _pageCheck : Container(),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget get _pageCheck {
    return Container(
      padding: const EdgeInsets.only(
        top: 42,
        left: 42,
      ),
      child: const CircleAvatar(
        radius: 14,
        backgroundColor: Colors.green,
        child: CircleAvatar(
          radius: 12,
          backgroundColor: Colors.black,
          child: Icon(
            Icons.check,
            color: Colors.green,
          ),
        ),
      ),
    );
  }

  Widget get _buttonCancelAddingPage {
    return SizedBox(
      height: 60,
      width: 60,
      child: FloatingActionButton(
        onPressed: () => Navigator.pop(context, _pagesList),
        child: const Icon(
          Icons.clear,
          size: 34,
        ),
      ),
    );
  }

  Widget get _buttonAddPage {
    return SizedBox(
      height: 60,
      width: 60,
      child: FloatingActionButton(
        onPressed: _addNewPage,
        child: const Icon(
          Icons.check,
          size: 34,
        ),
      ),
    );
  }
}
