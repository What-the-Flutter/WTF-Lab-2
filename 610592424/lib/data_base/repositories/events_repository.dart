import 'package:diploma/data_base/firebase_provider.dart';
import 'package:diploma/models/event.dart';
import 'package:flutter/material.dart';

class EventsRepository {
  late final FireBaseProvider _db;

  EventsRepository() {
    _db = FireBaseProvider();
  }

  Future<List<Event>> getAllEventsForEventHolder(int eventHolderId) {
    return _db.fetchAllEventsForEventHolder(eventHolderId);
  }

  Future<void> addEvent({
    required int eventholderId,
    String? text,
    int? iconIndex,
    String? imagePath,
  }) async {
    await _db.addEvent(Event.withoutId(
      text: text ?? '',
      eventholderId: eventholderId,
      imagePath: imagePath,
      iconIndex: iconIndex,
    ));
  }

  Future<void> updateEvent({
    required int eventholderId,
    required String text,
    required int eventId,
    DateTime? timeOfCreation,
    int? iconIndex,
  }) async {
    final newEvent = Event(
      eventId,
      text,
      eventholderId,
      iconIndex,
      null,
      timeOfCreation,
    );
    await _db.updateEvent(newEvent);
  }

  Future<void> deleteEvent(Event event) async {
    await _db.deleteEvent(event.eventId, hasImage: event.imagePath != null);
  }

  Future<Image> fetchImage(int id) async {
    return Image.memory(await _db.fetchImage(id));
  }

  Future<List<Event>> loadAllEvents() async {
    return await _db.fetchAllEvents();
  }
}
