import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../constants.dart';
import 'cubit/event_cubit.dart';

class TagsGrid extends StatelessWidget {
  final EventCubit eventCubit;

  const TagsGrid({Key? key, required this.eventCubit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _size = MediaQuery.of(context).size;
    return Container(
      height: _size.height * 0.03,
      child: BlocBuilder<EventCubit, EventState>(
        bloc: eventCubit,
        builder: (context, state) => ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: tagsList.length,
          itemBuilder: ((context, i) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: GestureDetector(
                onTap: (() {
                  if (state.selectedTag == i) {
                    eventCubit.tagSelect(-1);
                  } else {
                    eventCubit.tagSelect(i);
                  }
                }),
                child: Text(
                  tagsList[i],
                  style: TextStyle(
                    color: i == state.selectedTag
                        ? Theme.of(context).primaryColor
                        : Colors.black54,
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
