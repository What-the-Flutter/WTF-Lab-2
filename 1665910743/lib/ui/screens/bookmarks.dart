import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../constants.dart';
import '../../cubit/category_list_cubit.dart';
import '../../cubit/category_list_state.dart';
import '../widgets/event_tile.dart';

class BookmarkEvents extends StatelessWidget {
  final int id;

  const BookmarkEvents({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bookmarks'),
      ),
      body: Padding(
        padding: kListViewPadding,
        child: BlocBuilder<CategoryListCubit, CategoryListState>(
          bloc: context.read<CategoryListCubit>(),
          builder: ((context, state) {
            final list = state.categoryList[id].list;
            return ListView.builder(
              itemCount: list.length,
              itemBuilder: (context, index) {
                if (list[index].favorite == true) {
                  return Align(
                    alignment: Alignment.bottomLeft,
                    child: EventTile(
                      iconCode: list[index].iconCode,
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
            );
          }),
        ),
      ),
    );
  }
}
