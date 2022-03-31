import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubit/category_list_cubit.dart';
import '../../models/event_category.dart';
import '../../models/icons_pack.dart';
import '../theme/inherited_widget.dart';
import '../theme/theme_data.dart';

Future<dynamic> addTaskDialog(BuildContext context) {
  return showModalBottomSheet(
    isScrollControlled: true,
    backgroundColor: Colors.white.withOpacity(0.0),
    constraints: BoxConstraints(
      maxWidth: MediaQuery.of(context).size.width * 0.95,
    ),
    context: context,
    builder: (context) {
      return SingleChildScrollView(
        child: Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: ModalBody(),
        ),
      );
    },
  );
}

class ModalBody extends StatefulWidget {
  ModalBody({Key? key}) : super(key: key);

  @override
  State<ModalBody> createState() => _ModalBodyState();
}

class _ModalBodyState extends State<ModalBody> {
  final _controller = TextEditingController();
  bool _isSelected = false;
  int _selectedIndexAvatar = -1;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;
    return Container(
      constraints: BoxConstraints(maxHeight: _screenSize.height * 0.95),
      margin: EdgeInsets.only(top: _screenSize.height * 0.05),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      height: _screenSize.height * 0.45,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                  bottomLeft: Radius.circular(10),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _addTextField(_screenSize, context),
                  _addButton(context)
                ],
              ),
            ),
            SizedBox(
              height: _screenSize.height * 0.02,
            ),
            _iconGrid(_screenSize)
          ],
        ),
      ),
    );
  }

  Container _iconGrid(Size _screenSize) {
    return Container(
      constraints: BoxConstraints(maxHeight: _screenSize.height * 0.30),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 120,
            childAspectRatio: 3 / 2,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20),
        itemCount: kMyIcons.length,
        itemBuilder: (context, i) {
          return GestureDetector(
            onTap: () {
              setState(
                () {
                  _isSelected = !_isSelected;
                  _selectedIndexAvatar = i;
                },
              );
            },
            child: CircleAvatar(
              backgroundColor: (_selectedIndexAvatar == i)
                  ? Theme.of(context).primaryColor
                  : Theme.of(context).scaffoldBackgroundColor,
              foregroundColor:
                  (CustomTheme.of(context).theme == MyThemes.darkTheme)
                      ? ((_selectedIndexAvatar == i)
                          ? Colors.white
                          : Theme.of(context).primaryColor)
                      : ((_selectedIndexAvatar == i)
                          ? Colors.white
                          : Theme.of(context).primaryColor),
              radius: _screenSize.width * 0.13,
              child: CategoryIconButton(
                icon: kMyIcons[i],
                size: _screenSize.width * 0.13,
              ),
            ),
          );
        },
      ),
    );
  }

  Container _addTextField(Size _screenSize, BuildContext context) {
    return Container(
      width: _screenSize.width * 0.7,
      child: CupertinoTextField(
        placeholder: 'Enter the name',
        controller: _controller,
        style: TextStyle(
          fontSize: 20,
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }

  IconButton _addButton(BuildContext context) {
    return IconButton(
      onPressed: () {
        if (_selectedIndexAvatar == -1) {
          context.read<CategoryListCubit>().add(EventCategory(
                title: _controller.text,
                pined: false,
                icon: kMyIcons[7],
              ));
          Navigator.pop(
            context,
          );
        } else {
          context.read<CategoryListCubit>().add(EventCategory(
                title: _controller.text,
                pined: false,
                icon: kMyIcons[_selectedIndexAvatar],
              ));
          Navigator.pop(
            context,
          );
        }
      },
      icon: const Icon(
        Icons.send,
        color: Colors.white,
      ),
    );
  }
}
