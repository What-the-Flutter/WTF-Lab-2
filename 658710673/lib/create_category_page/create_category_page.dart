import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/category.dart';
import '../settings_page/settings_cubit.dart';
import '../utils/constants.dart';
import '../utils/theme/theme_cubit.dart';
import 'create_category_cubit.dart';
import 'create_category_state.dart';

class CreateCategoryPage extends StatefulWidget {
  final Category? editCategory;

  const CreateCategoryPage({
    Key? key,
    this.editCategory,
  }) : super(key: key);

  CreateCategoryPage.edit({
    Key? key,
    required this.editCategory,
  }) : super(key: key);

  @override
  _CreateCategoryPageState createState() => _CreateCategoryPageState();
}

class _CreateCategoryPageState extends State<CreateCategoryPage> {
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.editCategory != null) {
      _textController.text = widget.editCategory!.title;
      BlocProvider.of<CreateCategoryPageCubit>(context)
          .selectIcon(CategoryIcons.icons.indexOf(widget.editCategory!.icon));
    } else {
      BlocProvider.of<CreateCategoryPageCubit>(context).init();
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateCategoryPageCubit, CreateCategoryPageState>(
      builder: (context, state) {
        return Scaffold(
          body: Container(
            margin: const EdgeInsets.fromLTRB(16, 50, 16, 16),
            child: Column(
              children: [
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    (widget.editCategory == null) ? 'Create a new page' : 'Edit page',
                    style: TextStyle(
                      fontSize: BlocProvider.of<SettingsCubit>(context).state.fontSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.fromLTRB(0, 16, 0, 0),
                  child: TextField(
                    style: TextStyle(
                      fontSize: BlocProvider.of<SettingsCubit>(context).state.fontSize,
                      fontStyle: FontStyle.italic,
                    ),
                    controller: _textController,
                    maxLines: 1,
                    decoration: InputDecoration(
                      hintText: 'Name of the page',
                      filled: true,
                      contentPadding: const EdgeInsets.all(10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                _iconsGridView(state),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            child: _textController.text.isNotEmpty
                ? const Icon(
                    Icons.check,
                    color: Colors.black,
                  )
                : const Icon(
                    Icons.close,
                    color: Colors.black,
                  ),
            onPressed: () {
              if (_textController.text.isNotEmpty) {
                late Category category;
                if (widget.editCategory == null) {
                  category = Category.withoutId(
                    _textController.text,
                    CategoryIcons.icons[state.selectedIcon],
                  );
                } else {
                  category = widget.editCategory!.copyWith(
                      id: widget.editCategory!.timeOfCreation.millisecondsSinceEpoch,
                      title: _textController.text,
                      icon: CategoryIcons.icons[state.selectedIcon],
                      timeOfCreation: widget.editCategory!.timeOfCreation);
                }
                Navigator.of(context).pop(category);
              } else {
                Navigator.pop(context);
              }
            },
          ),
        );
      },
    );
  }

  Expanded _iconsGridView(CreateCategoryPageState state) {
    return Expanded(
      child: GridView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.all(8.0),
          child: GridTile(
            child: CircleAvatar(
              backgroundColor: state.selectedIcon != index
                  ? Colors.black12
                  : context.read<ThemeCubit>().state.colorScheme.primary,
              foregroundColor: Colors.white,
              child: IconButton(
                onPressed: () =>
                    BlocProvider.of<CreateCategoryPageCubit>(context).selectIcon(index),
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
