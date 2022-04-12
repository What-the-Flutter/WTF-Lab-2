import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../../constants.dart';
import '../../widgets/event_tile.dart';
import '../../widgets/event_tile_actions.dart';
import '../settings/cubit/settings_cubit.dart';
import 'cubit/event_cubit.dart';

class BookmarkEvents extends StatelessWidget {
  final _user = FirebaseAuth.instance.currentUser!.uid;

  BookmarkEvents({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _eventCubit = context.read<EventCubit>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bookmarks'),
      ),
      body: Container(
        padding: kListViewPadding,
        child: Expanded(
          child: BlocBuilder<EventCubit, EventState>(
            bloc: _eventCubit,
            builder: (context, state) {
              return ListView.builder(
                itemCount: state.eventList.length,
                itemBuilder: ((context, index) {
                  if (state.eventList[index].favorite) {
                    if (state.eventList[index].image.length > 2) {
                      context
                          .read<EventCubit>()
                          .getImage(state.eventList[index].title);
                    }

                    return Slidable(
                      startActionPane: ActionPane(
                        motion: const ScrollMotion(),
                        children: [
                          EditAction(
                            event: state.eventList[index],
                            eventKey: state.eventList[index].id!,
                          ),
                          RemoveAction(eventKey: state.eventList[index].id!),
                          MoveAction(eventKey: state.eventList[index].id!),
                        ],
                      ),
                      child: Align(
                        alignment: BlocProvider.of<SettingsCubit>(context)
                            .state
                            .chatTileAlignment,
                        child: EventTile(
                            iconCode: state.eventList[index].iconCode,
                            isSelected: state.eventList[index].isSelected,
                            title: state.eventList[index].title,
                            date: state.eventList[index].date,
                            favorite: state.eventList[index].favorite,
                            tag: state.eventList[index].tag,
                            image: (state.eventList[index].imageUrl != null)
                                ? Image.network(
                                    state.eventList[index].imageUrl!,
                                    width: 70,
                                    height: 70,
                                  )
                                : null),
                      ),
                    );
                  } else {
                    return const SizedBox();
                  }
                }),
              );
            },
          ),
        ),
      ),
    );
  }
}
