import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../constants.dart';
import '../../cubit/category_list_cubit.dart';
import '../screens/chat_screen.dart';
import 'edit_category_dialog.dart';

class UnpinedCategory extends StatefulWidget {
  const UnpinedCategory({Key? key}) : super(key: key);

  @override
  State<UnpinedCategory> createState() => _UnpinedCategoryState();
}

class _UnpinedCategoryState extends State<UnpinedCategory> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<CategoryListCubit>().state;

    return Padding(
      padding: kListViewPadding,
      child: CustomScrollView(
        slivers: [
          SliverList(
            delegate: SliverChildBuilderDelegate((context, i) {
              if (state.categoryList[i].pined == true) {
                return ListTile(
                  leading: CircleAvatar(
                    foregroundColor: Colors.white,
                    child: state.categoryList[i].icon,
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  trailing: Icon(
                    Icons.push_pin,
                    color: Theme.of(context).primaryColor,
                  ),
                  title: Text(state.categoryList[i].title),
                  subtitle: state.categoryList[i].list.isEmpty
                      ? const Text('No events')
                      : Text(state.categoryList[i].list.last.title),
                  onLongPress: () {
                    displayTextInputDialog(
                        category: context
                            .read<CategoryListCubit>()
                            .state
                            .categoryList[i],
                        categryIndex: i,
                        context: context,
                        pined: true);
                  },
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatScreen(
                          eventId: i,
                        ),
                      ),
                    );
                  },
                );
              } else {
                return const SizedBox();
              }
            }, childCount: state.categoryList.length),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, i) {
                if (state.categoryList[i].pined == false) {
                  return ListTile(
                    leading: CircleAvatar(
                      foregroundColor: Colors.white,
                      child: state.categoryList[i].icon,
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                    title: Text(state.categoryList[i].title),
                    subtitle: state.categoryList[i].list.isEmpty
                        ? const Text('No events')
                        : Text(state.categoryList[i].list.last.title),
                    onLongPress: () {
                      displayTextInputDialog(
                          category: context
                              .read<CategoryListCubit>()
                              .state
                              .categoryList[i],
                          categryIndex: i,
                          context: context,
                          pined: false);
                    },
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatScreen(
                            eventId: i,
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return const SizedBox();
                }
              },
              childCount: state.categoryList.length,
            ),
          ),
        ],
      ),
    );
  }
}
