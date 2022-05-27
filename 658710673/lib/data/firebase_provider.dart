import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../models/category.dart';
import '../models/event.dart';

class FirebaseProvider {
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  final DatabaseReference _ref = FirebaseDatabase.instance.ref();
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final User? user;

  FirebaseProvider({required this.user});

  Future<void> addCategory(Category category) async {
    try {
      await _ref
          .child(user?.uid ?? 'user')
          .child('categories/${category.timeOfCreation.millisecondsSinceEpoch}')
          .set(
            category.toMap(),
          );
    } catch (e) {
      print(e);
    }
  }

  Future<void> addEvent(Event event) async {
    final imagePath = event.attachment;
    File? file;
    if (imagePath != null) file = File('$imagePath');
    if (file != null) {
      try {
        await _storage
            .ref('${user?.uid ?? 'user'}/images/${event.timeOfCreation.millisecondsSinceEpoch}')
            .putFile(file);
      } catch (e) {
        print(e);
      }
    }

    try {
      _ref
          .child(user?.uid ?? 'user')
          .child('events/${event.timeOfCreation.millisecondsSinceEpoch}')
          .set(
            event.toMap(),
          );
    } catch (e) {
      print(e);
    }
  }

  Future<void> updateCategory(Category category) async {
    try {
      _ref
          .child(user?.uid ?? 'user')
          .child('categories/${category.timeOfCreation.millisecondsSinceEpoch}')
          .update(
            category.toMap(),
          );
    } catch (e) {
      print(e);
    }
  }

  Future<void> updateEvent(Event event) async {
    try {
      _ref
          .child(user?.uid ?? 'user')
          .child('events/${event.timeOfCreation.millisecondsSinceEpoch}')
          .update(
            event.toMap(),
          );
    } catch (e) {
      print(e);
    }
  }

  Future<void> deleteCategory(Category category) async {
    final databaseEvent = await _ref
        .child(user?.uid ?? 'user')
        .child('events')
        .orderByChild('category')
        .equalTo(category.id)
        .once();
    for (final child in databaseEvent.snapshot.children) {
      child.ref.remove();
    }
    try {
      _ref
          .child(user?.uid ?? 'user')
          .child('categories/${category.timeOfCreation.millisecondsSinceEpoch}')
          .remove();
    } catch (e) {
      print(e);
    }
  }

  Future<void> deleteEvent(Event event) async {
    try {
      _ref
          .child(user?.uid ?? 'user')
          .child('events/${event.timeOfCreation.millisecondsSinceEpoch}')
          .remove();
    } catch (e) {
      print(e);
    }
  }

  Future<void> deleteEvents(List<Event> events) async {
    try {
      for (final event in events) {
        deleteEvent(event);
      }
    } catch (e) {
      print(e);
    }
  }

  Future<List<Event>> getAllCategoryEvents(Category category) async {
    final events = <Event>[];
    final databaseEvent = await _ref
        .child(user?.uid ?? 'user')
        .child('events')
        .orderByChild(EventFields.category)
        .equalTo(category.id)
        .once();
    for (final child in databaseEvent.snapshot.children) {
      final map = child.value as Map<dynamic, dynamic>;
      final event = Event.fromMap(map);
      events.add(event);
    }
    return events;
  }

  Future<List<Event>> getAllEvents() async {
    final events = <Event>[];
    final databaseEvent = await _ref
        .child(user?.uid ?? 'user')
        .child('events')
        .once();
    for (final child in databaseEvent.snapshot.children) {
      final map = child.value as Map<dynamic, dynamic>;
      final event = Event.fromMap(map);
      events.add(event);
    }
    return events;
  }

  Future<List<Category>> getAllCategories() async {
    final categories = <Category>[];
    final databaseEvent = await _ref.child(user?.uid ?? 'user').child('categories').once();
    for (final child in databaseEvent.snapshot.children) {
      final map = child.value as Map<dynamic, dynamic>;
      final chat = Category.fromMap(map);
      categories.add(chat);
    }
    return categories;
  }
}
