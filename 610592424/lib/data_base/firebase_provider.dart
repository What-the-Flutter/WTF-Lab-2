// ignore_for_file: avoid_print

import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:diploma/homePage/models/event.dart';
import 'package:diploma/homePage/models/event_holder.dart';

class FireBaseProvider {
  final _ref = FirebaseDatabase.instanceFor(
    app: Firebase.app(),
    databaseURL:
        'https://diploma-8ba17-default-rtdb.europe-west1.firebasedatabase.app',
  ).ref();

  final _storage = FirebaseStorage.instance;

  FireBaseProvider();

  ///CRUD operations with Entities:

  //EventHolder:
  Future<List<EventHolder>> getAllEventHolders([int exceptId = -1]) async {
    final eventHolders = <EventHolder>[];
    final databaseEventHolder = await _ref
        .child('eventHolders')
        .orderByChild('eventholder_id')
        .once();
    if (exceptId == -1) {
      for (final child in databaseEventHolder.snapshot.children) {
        final map = child.value as Map<dynamic, dynamic>;
        final eventHolder = EventHolder.fromMap(map);
        eventHolders.add(eventHolder);
      }
    } else {
      for (final child in databaseEventHolder.snapshot.children) {
        final map = child.value as Map<dynamic, dynamic>;
        final eventHolder = EventHolder.fromMap(map);
        if (eventHolder.eventholderId == exceptId) {
          continue;
        }
        eventHolders.add(eventHolder);
      }
    }
    return eventHolders;
  }

  Future<EventHolder> getEventHolder(int id) async {
    final databaseEventHolder = await _ref
        .child('eventHolders')
        .orderByChild('eventholder_id')
        .equalTo(id)
        .once();
    assert(databaseEventHolder.snapshot.children.length == 1, 'wrong id');
    return EventHolder.fromMap(databaseEventHolder.snapshot.children.first.value
        as Map<dynamic, dynamic>);
  }

  Future<void> addEventHolder(EventHolder eventHolder) async {
    try {
      await _ref
          .child('eventHolders/${eventHolder.eventholderId}')
          .set(
            eventHolder.toMap(),
          );
    } catch (e) {
      print(e);
    }
  }

  Future<void> updateEventHolder(EventHolder eventHolder) async {
    try {
      await _ref
          .child('eventHolders/${eventHolder.eventholderId}')
          .update(
            eventHolder.toMap(),
          );
    } catch (e) {
      print(e);
    }
  }

  Future<void> deleteEventHolder(int id) async {
    try {
      await _ref.child('eventHolders/$id').remove();
      final databaseEvent = await _ref
          .child('events')
          .orderByChild('eventholder_id')
          .equalTo(id)
          .once();
      for (final child in databaseEvent.snapshot.children) {
        await child.ref.remove();
      }
    } catch (e) {
      print(e);
    }
  }

  //Events:
  Future<List<Event>> getAllEvents() async {
    final events = <Event>[];
    final databaseEvent = await _ref
        .child('events')
        .orderByChild('eventholder_id')
        .once();

    for (final child in databaseEvent.snapshot.children) {
      final map = child.value as Map<dynamic, dynamic>;
      final event = Event.fromMap(map);
      events.add(event);
    }
    return events;
  }

  Future<List<Event>> getAllEventsForEventHolder(int eventHolderId) async {
    final events = <Event>[];
    final databaseEvent = await _ref
        .child('events')
        .orderByChild('eventholder_id')
        .equalTo(eventHolderId)
        .once();

    for (final child in databaseEvent.snapshot.children) {
      final map = child.value as Map<dynamic, dynamic>;
      final event = Event.fromMap(map);
      events.add(event);
    }
    return events;
  }

  Future<void> addEvent(Event event) async {
    try {
      await _ref.child('events/${event.eventId}').set(
            event.toMap(),
          );
      if (event.imagePath != null) {
        await _storage
            .ref('images/${event.eventId}')
            .putFile(File(event.imagePath!));
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> updateEvent(Event event) async {
    try {
      await _ref.child('events/${event.eventId}').update(
            event.toMap(leavePrevDate: true),
          );
    } catch (e) {
      print(e);
    }
  }

  Future<void> deleteEvent(int id, {bool hasImage = true}) async {
    try {
      await _ref.child('events/$id').remove();
      if(hasImage){
        await _storage
            .ref('images/$id').delete();
      }
    } catch (e) {
      print(e);
    }
  }

  Future<Uint8List> fetchImage(int id) async {
    var photo = await _storage
        .ref('images/$id')
        .getData();
    assert(photo != null, 'incorrect id');
    return photo!;
  }
}
