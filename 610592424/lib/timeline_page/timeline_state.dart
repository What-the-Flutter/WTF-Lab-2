import 'package:diploma/home_page/models/event.dart';

class TimelineState {
  final bool anyHashtags;
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
