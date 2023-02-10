import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../data/models/message.dart';
import '../data/models/post.dart';

class FirebaseRepository {
  final DatabaseReference _postRef =
      FirebaseDatabase.instance.ref().child('posts');
  final DatabaseReference _messageRef =
      FirebaseDatabase.instance.ref().child('messages');
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  Stream<DatabaseEvent> listenPosts() async* {
    yield* _postRef.onValue;
  }

  Stream<DatabaseEvent> listenMessages(String postId) async* {
    yield* _messageRef.child(postId).onValue;
  }

  void addPost(Post post) async {
    await _postRef.push().set(
          post.toJson(),
        );
  }

  void editPost(Post post) async {
    await _postRef.child(post.id.toString()).update(post.toJson());
  }

  void deletePost(String postId) async {
    await _postRef.child(postId).remove();
  }

  Future<void> addMessage(Message message) async {
    await _messageRef.child(message.id.toString()).push().set(
          message.toJson(),
        );
  }

  Future<void> editMessage(Message message) async {
    await _messageRef.child(message.postId).child(message.id.toString()).update(
          message.toJson(),
        );
  }

  Future<void> deleteMessage(String postId, String messageId) async {
    await _messageRef.child(postId).child(messageId).remove();
  }
}

class MessageType {
  static const text = 0;
  static const image = 1;
}
