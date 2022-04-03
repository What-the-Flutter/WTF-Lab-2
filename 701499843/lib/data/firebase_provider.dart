import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';

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

  void insertChats(List<Chat> chats) {
    for (var chat in chats) {
      insertChat(chat);
    }
  }

  void insertEvent(Event event) async {
    var imagePath = event.image;
    File? file;
    if (imagePath != null) file = File('$imagePath');

    _ref.child('events/${event.id}').set(
          event.toMap(),
        );
    if (file != null) {
      await _storage.ref('images/${event.id}.png').putFile(file);
    }
  }

  void insertEvents(List<Event> events) {
    for (var event in events) {
      insertEvent(event);
    }
  }

  void insertIcon(EventIcon icon) {
    _ref.child('icons/${icon.id}').set(
          icon.toMap(),
        );
  }

  void insertIcons(List<EventIcon> icons) {
    for (var icon in icons) {
      insertIcon(icon);
    }
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
    for (var event in events) {
      removeEvent(event);
    }
  }

  void removeIcon(EventIcon icon) {
    _ref.child('icons/${icon.id}').remove();
  }

  Future<List<Event>> getEvents() async {
    var events = <Event>[];
    var databaseEvent =
        await _ref.child('events').orderByChild('timeOfCreation').once();
    for (final child in databaseEvent.snapshot.children) {
      final value = child.value as Map<dynamic, dynamic>;
      final event = Event.fromFirebase(value);
      events.add(event);
    }
    return events;
  }

  Future<List<Chat>> getChats() async {
    var chats = <Chat>[];
    var databaseEvent = await _ref.child('chats').once();
    for (final child in databaseEvent.snapshot.children) {
      final value = child.value as Map<dynamic, dynamic>;
      final chat = Chat.fromFirebase(value);
      chats.add(chat);
    }
    return chats;
  }

  Future<List<EventIcon>> getIcons() async {
    var icons = <EventIcon>[];
    var databaseEvent = await _ref.child('icons').once();
    for (final child in databaseEvent.snapshot.children) {
      final value = child.value as Map<dynamic, dynamic>;
      final icon = EventIcon.fromFirebase(value);
      icons.add(icon);
    }
    return icons;
  }

  void addChats() {
    insertChats(
      <Chat>[
        Chat(
          id: 0,
          category: 'Travel',
          icon: 12,
        ),
        Chat(
          id: 1,
          category: 'Family',
          icon: 13,
        ),
        Chat(
          id: 2,
          category: 'Sports',
          icon: 14,
        ),
      ],
    );
  }

  void addEvents() {
    insertEvents(<Event>[
      Event(
        id: 0,
        category: 'Travel',
        description: 'qqqq',
        isFavorite: false,
        isSelected: false,
        timeOfCreation: DateFormat('yyyy-MM-dd – kk:mm').format(DateTime.now()),
      ),
      Event(
        id: 1,
        category: 'Family',
        description: 'wwww',
        isFavorite: false,
        isSelected: false,
        timeOfCreation: DateFormat('yyyy-MM-dd – kk:mm').format(DateTime.now()),
      ),
      Event(
        id: 2,
        category: 'Sports',
        description: 'eeee',
        isFavorite: false,
        isSelected: false,
        timeOfCreation: DateFormat('yyyy-MM-dd – kk:mm').format(DateTime.now()),
      ),
    ]);
  }

  void addIcons() {
    insertIcons(
      <EventIcon>[
        EventIcon(
          id: 0,
          icon: 0,
        ),
        EventIcon(
          id: 1,
          icon: 1,
        ),
        EventIcon(
          id: 2,
          icon: 2,
        ),
        EventIcon(
          id: 3,
          icon: 3,
        ),
        EventIcon(
          id: 4,
          icon: 4,
        ),
        EventIcon(
          id: 5,
          icon: 5,
        ),
        EventIcon(
          id: 6,
          icon: 6,
        ),
        EventIcon(
          id: 7,
          icon: 7,
        ),
        EventIcon(
          id: 8,
          icon: 8,
        ),
        EventIcon(
          id: 9,
          icon: 9,
        ),
        EventIcon(
          id: 10,
          icon: 10,
        ),
        EventIcon(
          id: 11,
          icon: 11,
        ),
      ],
    );
  }
}
