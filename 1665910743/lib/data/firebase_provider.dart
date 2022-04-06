import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../models/event.dart';
import '../models/event_category.dart';
import '../repository/database_repository.dart';

class FireBaseRTDB implements DataBaseRepository {
  final FirebaseDatabase database = FirebaseDatabase.instance;
  final User? user;
  final DatabaseReference ref = FirebaseDatabase.instance.ref();

  FireBaseRTDB({required this.user});

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
    if (isImage != null) {
      try {
        final storageRef =
            FirebaseStorage.instance.ref('${user?.uid}/${event.title}');
        await storageRef.putFile(
          File(event.image!),
        );
      } catch (e) {
        print(e);
      }
    }
    try {
      await ref.child(user?.uid ?? 'user').child('events').push().set(
            event.toMap(),
          );
    } catch (e) {
      print(e);
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
      await ref.child(user!.uid).child('events').child(key).remove();
    } catch (e) {
      print(e);
    }
  }

  @override
  Future<void> renameCategory(String key, String newTitle) async {
    try {
      await ref
          .child(user!.uid)
          .child('category')
          .child(key)
          .update({'title': newTitle});
    } catch (e) {
      print(e);
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

    authKey = await ref.child(user!.uid).child('auth').get();

    return authKey.value as bool;
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
