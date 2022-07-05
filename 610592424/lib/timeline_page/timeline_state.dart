import 'package:diploma/models/event.dart';
import 'package:diploma/widgets/events_app_bar.dart';

class TimelineState {
  final bool anyHashtags;
  final List<Event> events;
  final List<int> eventHoldersFilter;
  final AppbarStates appbarState;

  TimelineState(
    this.events,
    this.anyHashtags,
    this.eventHoldersFilter,
    this.appbarState,
  );

  TimelineState copyWith({
    List<Event>? events,
    bool? anyHashtags,
    List<int>? eventHoldersFilter,
    AppbarStates? appbarState,
  }) {
    return TimelineState(
      events ?? this.events,
      anyHashtags ?? this.anyHashtags,
      eventHoldersFilter ?? this.eventHoldersFilter,
      appbarState ?? this.appbarState,
    );
  }
}
