import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../cubit/category_list_cubit.dart';
import '../../cubit/category_list_state.dart';
import '../widgets/edit_chat_item_dialog.dart';
import '../widgets/event_tile.dart';
import '../widgets/move_event_tile.dart';

class Daily extends StatelessWidget {
  static const title = 'Daily';

  const Daily({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = context.watch<CategoryListCubit>().state;

    return state.searchMode
     ? _searchBuilder(state)
      : _bodyList(state);
  }

  Widget _bodyList(CategoryListState state) {
    return ListView.builder(
        itemCount: state.allEvents.length,
        itemBuilder: (context, i) {
          return Slidable(
            startActionPane: ActionPane(
              motion: const ScrollMotion(),
              children: [
                SlidableAction(
                  onPressed: (context) => chatTileEditDialog(
                      title: state.allEvents[i].title,
                      context: context,
                      catIndex: state.allEvents[i].categoryIndex,
                      index: i),
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  foregroundColor: Theme.of(context).primaryColor,
                  icon: Icons.edit,
                ),
                SlidableAction(
                  onPressed: (context) {
                    context.read<CategoryListCubit>().removeEventInCategory(
                          title: state.allEvents[i].title,
                          categoryIndex: state.allEvents[i].categoryIndex,
                          eventIndex: i,
                        );
                    context.read<CategoryListCubit>().fetchAllEvents();
                  },
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  foregroundColor: Theme.of(context).primaryColor,
                  icon: Icons.delete,
                ),
                SlidableAction(
                  autoClose: true,
                  onPressed: (context) {
                    moveTile(
                        categoryIndex: state.allEvents[i].categoryIndex,
                        context: context,
                        eventIndex: i);
                    context.read<CategoryListCubit>().fetchAllEvents();
                  },
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  foregroundColor: Theme.of(context).primaryColor,
                  icon: Icons.move_down,
                ),
              ],
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  EventTile(
                    image: state.allEvents[i].image,
                    iconCode: state.allEvents[i].iconCode,
                    title: state.allEvents[i].title,
                    date: state.allEvents[i].date,
                    favorite: state.allEvents[i].favorite,
                    isSelected: state.allEvents[i].isSelected,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 15),
                    child: Text(
                      'from ${state.categoryList[state.allEvents[i].categoryIndex].title.toUpperCase()}',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  Widget _searchBuilder(CategoryListState state) {
    return ListView.builder(
        itemCount: state.allEvents.length,
        itemBuilder: (context, i) {
          return (state.allEvents[i].title == state.searchResult)
              ? Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        onTap: () => chatTileEditDialog(
                          title: state.allEvents[i].title,
                          context: context,
                          catIndex: state.allEvents[i].categoryIndex,
                          index: i,
                        ),
                        child: EventTile(
                          image: state.allEvents[i].image,
                          iconCode: state.allEvents[i].iconCode,
                          title: state.allEvents[i].title,
                          date: state.allEvents[i].date,
                          favorite: state.allEvents[i].favorite,
                          isSelected: state.allEvents[i].isSelected,
                        ),
                      ),
                      Text(
                        'from ${state.categoryList[state.allEvents[i].categoryIndex].title.toUpperCase()}',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ],
                  ),
                )
              : const SizedBox();
        });
  }
}
