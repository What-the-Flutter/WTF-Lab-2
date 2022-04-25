import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';

import '../models/event.dart';
import '../models/event_category.dart';
import '../repository/database_repository.dart';

class FireBaseRTDB implements DataBaseRepository {
  final User? user;

  final FirebaseDatabase database = FirebaseDatabase.instance;
  final DatabaseReference ref = FirebaseDatabase.instance.ref();

  FireBaseRTDB({required this.user});

  @override
  Future<List<EventCategory>> getCategorys() async {
    var events = <EventCategory>[];
    var databaseEvent = await ref
        .child(user?.uid ?? '')
        .child('category')
        .orderByChild('pinned')
        .once();
    for (final child in databaseEvent.snapshot.children) {
      final value = child.value as Map<dynamic, dynamic>;
      final event = EventCategory.fromMap(value);
      event.id = child.key;
      events.add(event);
    }
    return events;
  }

  @override
  Future<List<Event>> getEvents() async {
    var events = <Event>[];
    var databaseEvent = await ref
        .child(user?.uid ?? '')
        .child('events')
        .orderByChild('date')
        .once();
    for (final child in databaseEvent.snapshot.children) {
      final value = child.value as Map<dynamic, dynamic>;
      final event = Event.fromMap(value);
      event.id = child.key;
      events.add(event);
    }
    return events;
  }

  @override
  Future<List<Event>> updateEvents(List<Event> oldList) async {
    var events = <Event>[];
    var databaseEvent = await ref
        .child(user?.uid ?? '')
        .child('events')
        .orderByChild('date')
        .once();
    for (final child in databaseEvent.snapshot.children) {
      final value = child.value as Map<dynamic, dynamic>;
      final event = Event.fromMap(value);
      event.id = child.key;
      events.add(event);
    }

    events.removeWhere((element) => oldList.contains(element));

    return events;
  }

  @override
  Future<void> addCategory(
    EventCategory event,
  ) async {
    try {
      await ref.child(user?.uid ?? 'user').child('category').push().set(
            event.toMap(),
          );
    } catch (e) {
      print(e);
    }
  }

  @override
  Future<void> addEvent(Event event) async {
    final isImage = await event.image;

    if (isImage.length > 2) {
      try {
        final basename = basenameWithoutExtension(event.image);
        final storageRef =
            FirebaseStorage.instance.ref('${user?.uid}/$basename');
        await storageRef.putFile(
          File(event.image),
        );

        event.imageUrl = await getImageUrl(basename);

        await ref.child(user?.uid ?? 'user').child('events').push().set(
              event.toMap(),
            );
      } catch (e) {
        print(e);
      }
    } else {
      try {
        await ref.child(user?.uid ?? 'user').child('events').push().set(
              event.toMap(),
            );
      } catch (e) {
        print(e);
      }
    }
  }

  @override
  Future<void> bookmarkEvent(String key, bool isFavorite) async {
    try {
      await ref
          .child(user!.uid)
          .child('events')
          .child(key)
          .update({'favorite': isFavorite ? 0 : 1});
    } catch (e) {
      print(e);
    }
  }

  @override
  Future<void> moveEvent(String key, String newCategory) async {
    try {
      await ref
          .child(user!.uid)
          .child('events')
          .child(key)
          .update({'categoryTitle': newCategory});
    } catch (e) {
      print(e);
    }
  }

  @override
  Future<void> pinCategory(String key) async {
    try {
      await ref
          .child(user!.uid)
          .child('category')
          .child(key)
          .update({'pinned': 0});
    } catch (e) {
      print(e);
    }
  }

  @override
  Future<void> removeCategory(String key) async {
    try {
      await ref.child(user!.uid).child('category').child(key).remove();
    } catch (e) {
      print(e);
    }
  }

  @override
  Future<void> removeEvent(String key) async {
    try {
      final databaseEvent =
          await ref.child(user!.uid).child('events').child(key).once();
      final value = databaseEvent.snapshot.value as Map<dynamic, dynamic>;
      final eventFromMap = Event.fromMap(value);
      await ref.child(user!.uid).child('events').child(key).remove();
      if (eventFromMap.imageUrl != null) {
        final photoRef =
            await FirebaseStorage.instance.refFromURL(eventFromMap.imageUrl!);
        await photoRef.delete();
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Future<void> renameCategory(
      String key, String newTitle, String oldTitle) async {
    try {
      await ref
          .child(user!.uid)
          .child('category')
          .child(key)
          .update({'title': newTitle});
    } catch (e) {
      print(e);
    }
    var databaseEvent = await ref
        .child(user?.uid ?? '')
        .child('events')
        .orderByChild('date')
        .once();
    for (final child in databaseEvent.snapshot.children) {
      final value = child.value as Map<dynamic, dynamic>;
      if (value['categoryTitle'] == oldTitle) {
        try {
          await ref
              .child(user!.uid)
              .child('events')
              .child(child.key!)
              .update({'categoryTitle': newTitle});
        } catch (e) {
          print(e);
        }
      }
    }
  }

  @override
  Future<void> renameEvent(String key, String newTitle) async {
    try {
      await ref
          .child(user!.uid)
          .child('events')
          .child(key)
          .update({'title': newTitle});
    } catch (e) {
      print(e);
    }
  }

  @override
  Future<void> unpinCategory(String key) async {
    try {
      await ref
          .child(user!.uid)
          .child('category')
          .child(key)
          .update({'pinned': 1});
    } catch (e) {
      print(e);
    }
  }

  @override
  Future<void> eventSelected(String key) async {
    try {
      await ref
          .child(user!.uid)
          .child('events')
          .child(key)
          .update({'isSelected': 1});
    } catch (e) {
      print(e);
    }
  }

  @override
  Future<void> eventNotSelected(String key) async {
    try {
      await ref
          .child(user!.uid)
          .child('events')
          .child(key)
          .update({'isSelected': 0});
    } catch (e) {
      print(e);
    }
  }

  @override
  Future<void> setAuthKey(bool key) async {
    try {
      await ref.child(user!.uid).child('auth').set(key);
    } catch (e) {
      print(e);
    }
  }

  @override
  Future<bool> getAuthKey() async {
    DataSnapshot authKey;
    final bool key;
    authKey = await ref.child(user!.uid).child('auth').get();
    if (authKey.value == null) {
      key = false;
    } else {
      key = authKey.value as bool;
    }

    return key;
  }

  @override
  Future<String> getImageUrl(String name) async {
    final url = await FirebaseStorage.instance
        .ref()
        .child(user!.uid)
        .child(name)
        .getDownloadURL();

    return url;
  }

  @override
  Future<void> deleteDB() async {
    await ref.remove();
  }
}
