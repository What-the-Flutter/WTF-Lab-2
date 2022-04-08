import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../models/chat.dart';
import '../models/event.dart';
import '../models/event_icon.dart';

class FirebaseProvider {
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  final DatabaseReference _ref = FirebaseDatabase.instance.ref();
  final FirebaseStorage _storage = FirebaseStorage.instance;

  FirebaseProvider();

  void insertChat(Chat chat) {
    _ref.child('chats/${chat.id}').set(
          chat.toMap(),
        );
  }

  void insertEvent(Event event) async {
    final imagePath = event.image;
    File? file;
    if (imagePath != null) file = File('$imagePath');

    _ref.child('events/${event.id}').set(
          event.toMap(),
        );
    if (file != null) {
      await _storage.ref('images/${event.id}.png').putFile(file);
    }
  }

  void insertIcon(EventIcon icon) {
    _ref.child('icons/${icon.id}').set(
          icon.toMap(),
        );
  }

  void updateChat(Chat chat) {
    _ref.child('chats/${chat.id}').update(
          chat.toMap(),
        );
  }

  void updateEvent(Event event) {
    _ref.child('events/${event.id}').update(
          event.toMap(),
        );
  }

  void updateIcon(EventIcon icon) {
    _ref.child('icons/${icon.id}').update(
          icon.toMap(),
        );
  }

  void removeChat(Chat chat) {
    _ref.child('chats/${chat.id}').remove();
  }

  void removeEvent(Event event) {
    _ref.child('events/${event.id}').remove();
  }

  void removeEvents(List<Event> events) {
    for (final event in events) {
      removeEvent(event);
    }
  }

  void removeIcon(EventIcon icon) {
    _ref.child('icons/${icon.id}').remove();
  }

  Future<List<Event>> getEvents() async {
    final events = <Event>[];
    final databaseEvent =
        await _ref.child('events').orderByChild('timeOfCreation').once();
    for (final child in databaseEvent.snapshot.children) {
      final value = child.value as Map<dynamic, dynamic>;
      final event = Event.fromFirebase(value);
      events.add(event);
    }
    return events;
  }

  Future<List<Chat>> getChats() async {
    final chats = <Chat>[];
    final databaseEvent = await _ref.child('chats').once();
    for (final child in databaseEvent.snapshot.children) {
      final value = child.value as Map<dynamic, dynamic>;
      final chat = Chat.fromFirebase(value);
      chats.add(chat);
    }
    return chats;
  }

  Future<List<EventIcon>> getIcons() async {
    final icons = <EventIcon>[];
    final databaseEvent = await _ref.child('icons').once();
    for (final child in databaseEvent.snapshot.children) {
      final value = child.value as Map<dynamic, dynamic>;
      final icon = EventIcon.fromFirebase(value);
      icons.add(icon);
    }
    return icons;
  }
}
