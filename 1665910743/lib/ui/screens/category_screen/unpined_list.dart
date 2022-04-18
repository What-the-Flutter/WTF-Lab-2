import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../models/event_category.dart';
import '../chat_screen/chat_screen.dart';
import '../chat_screen/cubit/event_cubit.dart';
import 'cubit/category_cubit.dart';
import 'edit_category_dialog.dart';

class UnpinedCategory extends StatelessWidget {
  const UnpinedCategory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: BlocBuilder<CategoryCubit, CategoryState>(
        bloc: context.read<CategoryCubit>(),
        builder: (context, state) {
          return ListView.builder(
            itemCount: state.categoryList.length,
            itemBuilder: ((context, index) {
              final _events = context.read<EventCubit>().state.eventList.where(
                  (element) =>
                      element.categoryTitle == state.categoryList[index].title);
              final _subtitle =
                  _events.isNotEmpty ? _events.last.title : 'No events';
              return GestureDetector(
                onTap: (() => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: ((context) => ChatScreen(
                              categoryTitle: state.categoryList[index].title,
                            )),
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
                  subtitle: Text(
                    _subtitle,
                    style: Theme.of(context).textTheme.bodyText2,
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
