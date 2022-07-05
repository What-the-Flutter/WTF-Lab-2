import 'package:diploma/models/event.dart';
import 'package:diploma/widgets/events_app_bar.dart';

class EventListState {
  final List<Event> events;
  final AppbarStates appbarState;
  final bool anyHashtags;
  final int? tempEventId;
  final bool showIconsList;
  final int chosenIconIndex;
  final bool allowPhotoPick;

  EventListState({
    this.tempEventId,
    required this.showIconsList,
    required this.chosenIconIndex,
    required this.allowPhotoPick,
    required this.events,
    required this.anyHashtags,
    required this.appbarState,
  });

  EventListState copyWith({
    List<Event>? events,
    bool? anyHashtags,
    AppbarStates? appbarState,
    int? tempEventId,
    bool? showIconsList,
    int? chosenIconIndex,
    bool? allowPhotoPick,
  }) {
    return EventListState(
      events: events ?? this.events,
      anyHashtags: anyHashtags ?? this.anyHashtags,
      appbarState: appbarState ?? this.appbarState,
      allowPhotoPick: allowPhotoPick ?? this.allowPhotoPick,
      chosenIconIndex: chosenIconIndex ?? this.chosenIconIndex,
      showIconsList: showIconsList ?? this.showIconsList,
      tempEventId: tempEventId ?? this.tempEventId,
    );
  }
}
