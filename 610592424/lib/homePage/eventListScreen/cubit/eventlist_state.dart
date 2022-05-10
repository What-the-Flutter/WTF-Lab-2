import 'package:diploma/homePage/models/event.dart';

class EventListState{
  final List<Event> events;

  EventListState(this.events);

  EventListState copyWith(List<Event> events) {
    return EventListState(events);
  }
}