import 'package:diploma/homePage/models/event.dart';

class EventListState {
  bool anyHashtags;
  final List<Event> events;

  EventListState(this.events, this.anyHashtags);

  EventListState copyWith(List<Event>? events, [bool? anyHashtags]) {
    return EventListState(
      events ?? this.events,
      anyHashtags ?? this.anyHashtags,
    );
  }
}
