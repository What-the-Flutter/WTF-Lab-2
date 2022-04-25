import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../constants.dart';
import '../../../models/event_category.dart';
import '../../theme/theme_cubit/theme_cubit.dart';
import '../../theme/theme_data.dart';
import '../Category_Screen/cubit/category_cubit.dart';

Future<void> addTaskDialog(BuildContext context) {
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
          child: ModalBody(
            categoryCubit: context.read<CategoryCubit>(),
          ),
        ),
      );
    },
  );
}

class ModalBody extends StatefulWidget {
  final CategoryCubit categoryCubit;

  ModalBody({
    Key? key,
    required this.categoryCubit,
  }) : super(key: key);

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
    final screenSize = MediaQuery.of(context).size;

    return Container(
      constraints: BoxConstraints(maxHeight: screenSize.height * 0.95),
      margin: EdgeInsets.only(top: screenSize.height * 0.05),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.8),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      height: screenSize.height * 0.45,
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
                  _addTextField(screenSize, context),
                  _addButton(
                    context,
                    widget.categoryCubit,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: screenSize.height * 0.02,
            ),
            _iconGrid(screenSize)
          ],
        ),
      ),
    );
  }

  Widget _iconGrid(Size _screenSize) {
    return Container(
      constraints: BoxConstraints(maxHeight: _screenSize.height * 0.30),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 120,
            childAspectRatio: 3 / 2,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20),
        itemCount: iconPack.length,
        itemBuilder: (context, i) {
          return _categoryIconButton(
            i,
            context,
            _screenSize,
          );
        },
      ),
    );
  }

  Widget _categoryIconButton(
    int i,
    BuildContext context,
    Size _screenSize,
  ) {
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
            (context.read<ThemeCubit>().state == MyThemes.darkTheme)
                ? ((_selectedIndexAvatar == i)
                    ? Colors.white
                    : Theme.of(context).primaryColor)
                : ((_selectedIndexAvatar == i)
                    ? Colors.white
                    : Theme.of(context).primaryColor),
        radius: _screenSize.width * 0.13,
        child: Icon(
          iconPack[i].icon,
          size: _screenSize.width * 0.13,
        ),
      ),
    );
  }

  Widget _addTextField(Size _screenSize, BuildContext context) {
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

  Widget _addButton(BuildContext context, CategoryCubit cubit) {
    return IconButton(
      onPressed: () {
        if (_selectedIndexAvatar == -1) {
          cubit.add(EventCategory(
            title: _controller.text,
            pinned: false,
            icon: iconPack[7],
          ));
          Navigator.pop(
            context,
          );
        } else {
          cubit.add(EventCategory(
            title: _controller.text,
            pinned: false,
            icon: iconPack[_selectedIndexAvatar],
          ));
          Navigator.pop(
            context,
          );
        }
      },
      icon: Icon(
        Icons.send,
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
    );
  }
}
