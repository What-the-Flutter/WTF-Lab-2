import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../../constants.dart' as constats;
import '../../widgets/event_tile.dart';
import '../../widgets/event_tile_actions.dart';
import '../settings/cubit/settings_cubit.dart';
import 'cubit/event_cubit.dart';

class BookmarkEvents extends StatelessWidget {
  final EventCubit eventCubit;

  BookmarkEvents({
    Key? key,
    required this.eventCubit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bookmarks'),
      ),
      body: Container(
        padding: constats.listViewPadding,
        child: BlocBuilder<EventCubit, EventState>(
          bloc: eventCubit,
          builder: (context, state) {
            return ListView.builder(
              itemCount: state.eventList.length,
              itemBuilder: ((context, index) {
                if (state.eventList[index].favorite) {
                  return Slidable(
                    startActionPane: ActionPane(
                      motion: const ScrollMotion(),
                      children: [
                        EditAction(
                          eventCubit: eventCubit,
                          event: state.eventList[index],
                          eventKey: state.eventList[index].id!,
                        ),
                        RemoveAction(
                            eventCubit: eventCubit,
                            eventKey: state.eventList[index].id!),
                        MoveAction(
                          eventKey: state.eventList[index].id!,
                          categoryName: state.eventList[index].categoryTitle,
                        ),
                      ],
                    ),
                    child: Align(
                      alignment:
                          context.read<SettingsCubit>().state.chatTileAlignment,
                      child: EventTile(
                          iconCode: state.eventList[index].iconCode,
                          isSelected: state.eventList[index].isSelected,
                          title: state.eventList[index].title,
                          date: state.eventList[index].date,
                          favorite: state.eventList[index].favorite,
                          tag: state.eventList[index].tag,
                          image: (state.eventList[index].imageUrl != null)
                              ? Image(
                                  image: CachedNetworkImageProvider(
                                      state.eventList[index].imageUrl!),
                                  width:
                                      MediaQuery.of(context).size.width * 0.5,
                                  height:
                                      MediaQuery.of(context).size.height * 0.3,
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
    );
  }
}
