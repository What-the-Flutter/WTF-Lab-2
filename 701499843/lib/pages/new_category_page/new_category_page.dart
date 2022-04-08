import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/icons.dart';
import '../../models/chat.dart';
import 'new_category_page_cubit.dart';
import 'new_category_page_state.dart';

class NewCategoryPage extends StatefulWidget {
  final String title;
  late final Icon? icon;

  NewCategoryPage({
    Key? key,
    this.title = '',
    this.icon,
  }) : super(key: key);

  NewCategoryPage.edit({
    Key? key,
    required this.title,
    required this.icon,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _NewCategoryPageState();
}

class _NewCategoryPageState extends State<NewCategoryPage> {
  final _controller = TextEditingController();
  late final NewCategoryPageCubit _cubit;

  @override
  void initState() {
    super.initState();

    _cubit = BlocProvider.of<NewCategoryPageCubit>(context);
    _cubit.init();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NewCategoryPageCubit, NewCategoryPageState>(
      bloc: _cubit,
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).primaryColor,
            title: const Text('Create a new Page'),
            centerTitle: true,
          ),
          body: _body(state),
          floatingActionButton: _floatingActionButton(state),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _floatingActionButton(NewCategoryPageState state) {
    return FloatingActionButton(
      onPressed: () => {
        if (_controller.text.isNotEmpty &&
            state.iconsList
                .where((element) => element.isSelected == true)
                .isNotEmpty)
          {
            Navigator.pop(
              context,
              {
                Chat(
                  id: state.iconsList
                      .where((element) => element.isSelected == true)
                      .first
                      .id,
                  category: _controller.text,
                  icon: state.iconsList
                      .where((element) => element.isSelected == true)
                      .first
                      .icon,
                ),
              },
            ),
          },
      },
      child: Icon(
        Icons.check,
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
    );
  }

  Widget _body(NewCategoryPageState state) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(40),
      child: Column(
        children: [
          TextField(
            onChanged: _cubit.changeWritingMode,
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
          _iconsGrid(state),
        ],
      ),
    );
  }

  Widget _iconsGrid(NewCategoryPageState state) {
    return Expanded(
      child: GridView.builder(
        itemCount: state.iconsList.length,
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
                  icon: icons.elementAt(state.iconsList[index].icon),
                  onPressed: () => _cubit.selectIcon(index),
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
