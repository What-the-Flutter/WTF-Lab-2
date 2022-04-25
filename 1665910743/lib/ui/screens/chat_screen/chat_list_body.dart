import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../widgets/event_tile.dart';
import '../../widgets/event_tile_actions.dart';
import '../settings/cubit/settings_cubit.dart';
import 'cubit/event_cubit.dart';

class ChatListBody extends StatefulWidget {
  final EventCubit eventCubit;
  final String categoryTitle;

  const ChatListBody({
    Key? key,
    required this.categoryTitle,
    required this.eventCubit,
  }) : super(key: key);

  @override
  State<ChatListBody> createState() => _ChatListBodyState();
}

class _ChatListBodyState extends State<ChatListBody> {
  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text)).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Text copied to clipboard'),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: BlocBuilder<EventCubit, EventState>(
        bloc: widget.eventCubit,
        builder: (context, state) {
          return GestureDetector(
            onTap: () {
              for (var element in state.eventList) {
                widget.eventCubit.eventNotSelect(element.id!);
              }
            },
            child: ListView.builder(
              itemCount: state.eventList.length,
              itemBuilder: ((context, index) {
                if (widget.categoryTitle ==
                    state.eventList[index].categoryTitle) {
                  return Slidable(
                    startActionPane: ActionPane(
                      motion: const ScrollMotion(),
                      children: [
                        EditAction(
                          eventCubit: widget.eventCubit,
                          event: state.eventList[index],
                          eventKey: state.eventList[index].id!,
                        ),
                        RemoveAction(
                            eventCubit: widget.eventCubit,
                            eventKey: state.eventList[index].id!),
                        MoveAction(
                          eventKey: state.eventList[index].id!,
                          categoryName: state.eventList[index].categoryTitle,
                        ),
                      ],
                    ),
                    child: Align(
                      alignment: BlocProvider.of<SettingsCubit>(context)
                          .state
                          .chatTileAlignment,
                      child: GestureDetector(
                        onDoubleTap: () =>
                            _copyToClipboard(state.eventList[index].title),
                        onLongPress: () {
                          if (state.eventList[index].isSelected == false) {
                            widget.eventCubit
                                .eventSelect(state.eventList[index].id!);
                          } else {
                            widget.eventCubit
                                .eventNotSelect(state.eventList[index].id!);
                          }
                          HapticFeedback.heavyImpact();
                        },
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
                                    height: MediaQuery.of(context).size.height *
                                        0.3,
                                    fit: BoxFit.cover,
                                  )
                                : null),
                      ),
                    ),
                  );
                } else {
                  return const SizedBox();
                }
              }),
            ),
          );
        },
      ),
    );
  }
}
