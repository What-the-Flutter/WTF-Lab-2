import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:page_transition/page_transition.dart';

import '../../../data/models/event.dart';
import '../../constants/constants.dart';
import '../../screens/chat/chat_screen.dart';
import '../../screens/home/home_cubit.dart';

class EventTile extends StatelessWidget {
  late final HomeCubit _cubit;
  final Event event;

  EventTile({
    super.key,
    required this.event,
  });

  @override
  Widget build(BuildContext context) {
    _cubit = context.read<HomeCubit>();
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppPadding.kBigPadding,
        vertical: AppPadding.kSmallPadding,
      ),
      child: Slidable(
        startActionPane: ActionPane(
          extentRatio: 0.30,
          motion: const DrawerMotion(),
          children: [
            SlidableAction(
              autoClose: true,
              onPressed: (context) {
                _cubit.likeEvent(event);
              },
              backgroundColor: Theme.of(context).colorScheme.background,
              foregroundColor: Theme.of(context).colorScheme.onBackground,
              icon: Icons.favorite_outline,
            ),
            SlidableAction(
              autoClose: true,
              onPressed: (context) {
                //TODO complete event
              },
              backgroundColor: Theme.of(context).colorScheme.background,
              foregroundColor: Theme.of(context).colorScheme.onBackground,
              icon: Icons.done,
            ),
          ],
        ),
        endActionPane: ActionPane(
          extentRatio: 0.30,
          motion: const DrawerMotion(),
          children: [
            SlidableAction(
              autoClose: true,
              onPressed: (context) {
                //TODO edit event
              },
              backgroundColor: Theme.of(context).colorScheme.background,
              foregroundColor: Theme.of(context).colorScheme.onBackground,
              icon: Icons.edit,
            ),
            SlidableAction(
              autoClose: true,
              onPressed: (context) {
                _cubit.deleteEvent(event);
              },
              backgroundColor: Theme.of(context).colorScheme.background,
              foregroundColor: Theme.of(context).colorScheme.onBackground,
              icon: Icons.delete,
            ),
          ],
        ),
        child: GestureDetector(
          onTap: () {
            _cubit.setSelectedEvent(event);
            Navigator.push(
              context,
              PageTransition(
                type: PageTransitionType.rightToLeft,
                child: const ChatScreen(),
                duration: const Duration(milliseconds: 250),
              ),
            );
          },
          child: Container(
            width: double.infinity,
            height: 70,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF000000).withOpacity(0.1),
                  offset: const Offset(2, 2),
                  blurRadius: 10,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(AppPadding.kSmallPadding),
              child: Row(
                children: [
                  Container(
                    width: 58,
                    height: 58,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: const Color(0xFF374A48),
                    ),
                    child: Icon(
                      event.iconData,
                      color: const Color(0xFFFAFAFA),
                      size: 36,
                    ),
                  ),
                  const SizedBox(width: AppPadding.kMediumPadding),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        event.title,
                        style: const TextStyle(
                          fontSize: 20,
                          color: Color(0xFF374A48),
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.sms_outlined,
                            size: 18,
                            color: Color(0xFF374A48),
                          ),
                          const SizedBox(width: AppPadding.kSmallPadding),
                          Text(
                            event.lastMessage,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF374A48),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
