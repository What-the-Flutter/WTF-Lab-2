import '../../models/event.dart';
import '../firebase_provider.dart';

class EventsRepository {
  final FirebaseProvider _db = FirebaseProvider();
  EventsRepository();

  Future<List<Event>> getEvents() async {
    return await _db.getEvents();
  }

  void insertEvent(Event event) {
    _db.insertEvent(event);
  }

  void updateEvent(Event event) {
    _db.updateEvent(event);
  }

  void removeEvent(Event event) {
    _db.removeEvent(event);
  }

  void removeEvents(List<Event> events) {
    _db.removeEvents(events);
  }
}
