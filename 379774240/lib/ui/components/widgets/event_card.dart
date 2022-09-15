import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';

import '../../../data/models/event.dart';
import '../../constants/constants.dart';
import '../../screens/chat/chat_screen.dart';
import '../../screens/home/home_cubit.dart';

class EventCard extends StatelessWidget {
  late final HomeCubit _cubit;
  final Event event;

  EventCard({
    super.key,
    required this.event,
  });

  @override
  Widget build(BuildContext context) {
    _cubit = context.read<HomeCubit>();
    return GestureDetector(
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
        width: 166,
        height: 166,
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(AppPadding.kSmallPadding),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: const Color(0xFF374A48),
                    ),
                    child: Icon(
                      event.iconData,
                      color: const Color(0xFFFAFAFA),
                      size: 48,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(AppPadding.kSmallPadding),
                    child: GestureDetector(
                      onTap: () {
                        _cubit.likeEvent(event);
                      },
                      child: Icon(
                        Icons.favorite,
                        color: Theme.of(context).colorScheme.secondary,
                        size: 24,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppPadding.kSmallPadding,
                0,
                0,
                AppPadding.kSmallPadding,
              ),
              child: Text(
                event.title,
                style: const TextStyle(
                  fontSize: 24,
                  color: Color(0xFF374A48),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppPadding.kSmallPadding,
                0,
                0,
                AppPadding.kSmallPadding,
              ),
              child: Row(
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
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppPadding.kSmallPadding,
                0,
                0,
                AppPadding.kSmallPadding,
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.history_outlined,
                    size: 18,
                    color: Color(0xFF374A48),
                  ),
                  const SizedBox(width: AppPadding.kSmallPadding),
                  Text(
                    'Last activity: ${event.lastActivity}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF374A48),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
