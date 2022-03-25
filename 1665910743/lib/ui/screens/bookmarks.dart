import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../constants.dart';
import '../../cubit/categorylist_cubit.dart';
import '../widgets/event_tile.dart';

class BookmarkEvents extends StatelessWidget {
  final int id;

  const BookmarkEvents({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var list = context.watch<CategorylistCubit>().state.categoryList[id].list;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bookmarks'),
      ),
      body: Padding(
        padding: kListViewPadding,
        child: ListView.builder(
          itemCount: list.length,
          itemBuilder: (context, index) {
            if (list[index].favorite == true) {
              return Align(
                alignment: Alignment.bottomLeft,
                child: EventTile(
                  isSelected: list[index].isSelected,
                  title: list[index].title,
                  date: list[index].date,
                  favorite: list[index].favorite,
                  image: list[index].image,
                ),
              );
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }
}
