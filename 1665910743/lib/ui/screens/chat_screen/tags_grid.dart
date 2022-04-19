import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../models/tags.dart';
import 'cubit/event_cubit.dart';

class TagsGrid extends StatelessWidget {
  const TagsGrid({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _eventCubit = context.watch<EventCubit>();
    final _size = MediaQuery.of(context).size;
    return Container(
      height: _size.height * 0.03,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: kTags.length,
        itemBuilder: ((context, i) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: GestureDetector(
              onTap: (() {
                if (_eventCubit.state.selectedTag == i) {
                  context.read<EventCubit>().tagSelect(-1);
                } else {
                  context.read<EventCubit>().tagSelect(i);
                }
              }),
              child: Text(
                kTags[i],
                style: TextStyle(
                  color: i == _eventCubit.state.selectedTag
                      ? Theme.of(context).primaryColor
                      : Colors.black54,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
