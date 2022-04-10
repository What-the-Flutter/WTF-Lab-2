import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../models/event_category.dart';
import '../chat_screen/chat_screen.dart';
import 'cubit/category_cubit.dart';
import 'edit_category_dialog.dart';

class UnpinedCategory extends StatefulWidget {
  const UnpinedCategory({Key? key}) : super(key: key);

  @override
  State<UnpinedCategory> createState() => _UnpinedCategoryState();
}

class _UnpinedCategoryState extends State<UnpinedCategory> {
  @override
  void didChangeDependencies() {
    context.read<CategoryCubit>().getCat();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: BlocBuilder<CategoryCubit, CategoryState>(
        bloc: context.read<CategoryCubit>(),
        builder: (context, state) {
          return ListView.builder(
            itemCount: state.categoryList.length,
            itemBuilder: ((context, index) {
              return GestureDetector(
                onTap: (() => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: ((context) => ChatScreen(
                            categoryTitle: state.categoryList[index].title)),
                      ),
                    )),
                onLongPress: () {
                  HapticFeedback.heavyImpact();
                  displayTextInputDialog(
                      context: context,
                      category: EventCategory(
                        title: state.categoryList[index].title,
                        pinned: state.categoryList[index].pinned,
                        icon: const Icon(Icons.ads_click),
                      ),
                      pinned: state.categoryList[index].pinned,
                      key: state.categoryList[index].id!);
                },
                child: ListTile(
                  leading: CircleAvatar(
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Colors.white,
                      child: state.categoryList[index].icon),
                  title: Text(
                    state.categoryList[index].title,
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  trailing: (state.categoryList[index].pinned)
                      ? Icon(
                          Icons.push_pin_rounded,
                          color: Theme.of(context).primaryColor,
                        )
                      : null,
                ),
              );
            }),
          );
        },
      ),
    );
  }
}
