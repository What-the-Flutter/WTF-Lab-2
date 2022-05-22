// ignore_for_file: avoid_print

import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:diploma/homePage/models/event.dart';
import 'package:diploma/homePage/models/event_holder.dart';

class FireBaseProvider {
  final DatabaseReference _ref = FirebaseDatabase.instanceFor(
    app: Firebase.app(),
    databaseURL:
        'https://diploma-8ba17-default-rtdb.europe-west1.firebasedatabase.app',
  ).ref();

  final FirebaseStorage _storage = FirebaseStorage.instance;
  final User _user;

  FireBaseProvider(this._user);

  ///CRUD operations with Entities:

  //EventHolder:
  Future<List<EventHolder>> getAllEventHolders([int exceptId = -1]) async {
    final eventHolders = <EventHolder>[];
    final databaseEventHolder = await _ref
        .child(_user.uid)
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
        .child(_user.uid)
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
          .child(_user.uid)
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
          .child(_user.uid)
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
      await _ref.child(_user.uid).child('eventHolders/$id').remove();
      final databaseEvent = await _ref
          .child(_user.uid)
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
  Future<List<Event>> getAllEventsForEventHolder(int eventHolderId) async {
    final events = <Event>[];
    final databaseEvent = await _ref
        .child(_user.uid)
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
      await _ref.child(_user.uid).child('events/${event.eventId}').set(
            event.toMap(),
          );
      if (event.imagePath != null) {
        await _storage
            .ref('${_user.uid}/images/${event.eventId}')
            .putFile(File(event.imagePath!));
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> updateEvent(Event event) async {
    try {
      await _ref.child(_user.uid).child('events/${event.eventId}').update(
            event.toMap(),
          );
    } catch (e) {
      print(e);
    }
  }

  Future<void> deleteEvent(int id, {bool hasImage = true}) async {
    try {
      await _ref.child(_user.uid).child('events/$id').remove();
      if(hasImage){
        await _storage
            .ref('${_user.uid}/images/$id').delete();
      }
    } catch (e) {
      print(e);
    }
  }

  Future<Uint8List> fetchImage(int id) async {
    var photo = await _storage
        .ref('${_user.uid}/images/$id')
        .getData();
    assert(photo != null, 'incorrect id');
    return photo!;
  }
}
