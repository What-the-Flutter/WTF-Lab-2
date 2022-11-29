import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../../utils/message.dart';

class MessagesRepository {
  final ref = FirebaseDatabase.instance.ref();
  final storageRef = FirebaseStorage.instance.ref();

  Future checkForUpdates({required Function onUpdate}) async {
    ref.child('messages').onValue.listen(
          (event) => onUpdate(),
        );
  }

  Future<List<Message>> getAllMessages() async {
    final snapshot = await ref.child('messages').get();

    final messages = <Message>[];
    if (snapshot.exists) {
      for (final child in snapshot.children) {
        messages.add(
          Message.fromJson(
            Map<String, dynamic>.from(child.value as Map<Object?, Object?>),
          ),
        );
      }
    } else {
      print('Error with firebase');
    }
    return messages;
  }

  String? addMessage(Message message) {
    final newRef = ref.child('messages').push();
    newRef.set(message.copyWith(id: newRef.key).toJson());
    return newRef.key;
  }

  void editMessage(Message message) async {
    final snapshot = await ref.child('messages/${message.id}');
    snapshot.update(message.toJson());
  }

  void deleteMessage(Message message) async {
    final id = message.id;
    if (id != null) {
      final snapshot = await ref.child('messages/$id');
      deletePicture(id);
      snapshot.remove();
    }
  }

  Future<String> uploadPicture(File file, String id) async {
    final pictureRef = storageRef.child('images/$id.jpg');
    await pictureRef.putFile(file);
    return await storageRef.child('images/$id.jpg').getDownloadURL();
  }

  void deletePicture(String id) async {
    final pictureRef = storageRef.child('images/$id.jpg');
    await pictureRef.delete();
  }

  Future<String> editPicture(File file, String id) async {
    final pictureRef = storageRef.child('images/$id.jpg');
    await pictureRef.putFile(file);
    return await storageRef.child('images/$id.jpg').getDownloadURL();
  }
}
