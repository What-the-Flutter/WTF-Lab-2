import 'package:firebase_database/firebase_database.dart';

import '../../data/models/app_state.dart';
import '../../data/models/event.dart';
import '../../data/models/note.dart';

class DatabaseProvider {
  final FirebaseDatabase instance = FirebaseDatabase.instance;
  final DatabaseReference appStateRef =
      FirebaseDatabase.instance.ref().child('appState');
  final DatabaseReference eventsRef =
      FirebaseDatabase.instance.ref().child('events');
  final DatabaseReference notesRef =
      FirebaseDatabase.instance.ref().child('notes');

  void createEvent(Event event) async {
    await eventsRef.push().set(event.toMap());
  }

  Stream<DatabaseEvent> listenEvents() async* {
    yield* eventsRef.onValue;
  }

  Future<List<Event>> fetchEvents() async {
    var events = <Event>[];
    var snapshot = await eventsRef.get();
    var data = (snapshot.value ?? {}) as Map;
    data.forEach(((key, value) {
      events.add(Event.fromMap({'id': key, ...value}));
    }));
    return events;
  }

  Future<Event> readEvent(String eventId) async {
    var snapshot = await eventsRef.child(eventId).get();
    var map = snapshot.value as Map;
    return Event.fromMap({'id': eventId, ...map});
  }

  void updateEvent(String eventId, Event newEvent) async {
    await eventsRef.child(eventId).update(newEvent.toMap());
  }

  void deleteEvent(String eventId) async {
    await eventsRef.child(eventId).remove();
  }

  void updateAppState(AppState appState) async {
    await appStateRef.update(appState.toMap());
  }

  Future<AppState> readAppState() async {
    var snapshot = await appStateRef.get();
    var map = snapshot.value as Map;
    return AppState.fromMap({...map});
  }

  // NOTES

  Future createNote(Note note) async {
    await notesRef.child(note.eventId).push().set(note.toMap());
  }

  Stream<DatabaseEvent> listenNotes(String eventId) async* {
    yield* notesRef.child(eventId).onValue;
  }

  Future deleteNote(String eventId, String noteId) async {
    await notesRef.child(eventId).child(noteId).remove();
  }

  void editNote(Note note, String newText) async {
    await notesRef.child(note.eventId).child(note.id!).update({
      'text': newText,
    });
  }
}
