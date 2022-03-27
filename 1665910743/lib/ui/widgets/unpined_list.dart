import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../constants.dart';
import '../../cubit/categorylist_cubit.dart';
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
  Widget build(BuildContext context) {
    final state = context.watch<CategorylistCubit>().state;

    return Padding(
      padding: kListViewPadding,
      child: CustomScrollView(
        slivers: [
          SliverList(
            delegate: SliverChildBuilderDelegate(
                (context, i) => ListTile(
                      trailing: Icon(
                        Icons.push_pin,
                        color: Theme.of(context).primaryColor,
                      ),
                      leading: CircleAvatar(
                        foregroundColor: Colors.white,
                        child: state.pinedList[i].icon,
                        backgroundColor: Theme.of(context).primaryColor,
                      ),
                      title: Text(state.pinedList[i].title),
                      subtitle: state.pinedList[i].list.isEmpty
                          ? const Text('No events')
                          : Text(state.pinedList[i].list.last.title),
                      onLongPress: () async {
                        await displayTextInputDialog(
                            category: context
                                .read<CategorylistCubit>()
                                .state
                                .pinedList[i],
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
                    ),
                childCount: state.pinedList.length),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, i) => ListTile(
                leading: CircleAvatar(
                  foregroundColor: Colors.white,
                  child: state.categoryList[i].icon,
                  backgroundColor: Theme.of(context).primaryColor,
                ),
                title: Text(state.categoryList[i].title),
                subtitle: state.categoryList[i].list.isEmpty
                    ? const Text('No events')
                    : Text(state.categoryList[i].list.last.title),
                onLongPress: () async {
                  await displayTextInputDialog(
                      category: context
                          .read<CategorylistCubit>()
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
              ),
              childCount: state.categoryList.length,
            ),
          ),
        ],
      ),
    );
  }
}
