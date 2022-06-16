import 'package:diploma/homePage/models/event.dart';

class TimelineState {
  bool anyHashtags;
  final List<Event> events;
  final List<int> eventHoldersFilter;

  TimelineState(this.events, this.anyHashtags, this.eventHoldersFilter);

  TimelineState copyWith({
    List<Event>? events,
    bool? anyHashtags,
    List<int>? eventHoldersFilter,
  }) {
    return TimelineState(
      events ?? this.events,
      anyHashtags ?? this.anyHashtags,
      eventHoldersFilter ?? this.eventHoldersFilter,
    );
  }
}
