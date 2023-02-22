import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../data/models/message.dart';
import '../data/models/post.dart';

class FirebaseRepository {
  final DatabaseReference _postRef =
      FirebaseDatabase.instance.ref().child('/posts');
  final DatabaseReference _messageRef =
      FirebaseDatabase.instance.ref().child('/messages');
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  Future<List<Post>> getAllPosts() async {
    final pList = <Post>[];
    final resultList = <dynamic>[];
    final childKeyList = <dynamic>[];
    final childPostKeyList = <dynamic>[];
    final snap = await _postRef.once();
    for (var childSnapshot in snap.snapshot.children) {
      var childKey = childSnapshot.key;
      childKeyList.add(childKey);
    }
    DatabaseEvent snapPost;
    for (var i = 0; i < childKeyList.length; i++) {
      snapPost = await _postRef.child(childKeyList[i]).once();
      for (var childSnapshot in snapPost.snapshot.children) {
        var childPostKey = childSnapshot.key;
        childPostKeyList.add(childPostKey);
        resultList.add(snapPost.snapshot.child(childPostKeyList[i]).value);
      }
      final result = resultList[i];
      print(result);
      pList.add(
        Post.fromJson(
          Map<String, dynamic>.from(result),
        ),
      );
    }
    return pList;
  }

  Future<List<Message>> getAllMessages() async {
    final mList = <Message>[];
    final resultList = <dynamic>[];
    final childKeyList = <dynamic>[];
    final childMessageKeyList = <dynamic>[];
    final snap = await _messageRef.once();
    for (var childSnapshot in snap.snapshot.children) {
      var childKey = childSnapshot.key;
      childKeyList.add(childKey);
    }
    DatabaseEvent snapMessages;
    for (var i = 0; i < childKeyList.length; i++) {
      snapMessages = await _messageRef.child(childKeyList[i]).once();
      for (var childSnapshot in snapMessages.snapshot.children) {
        var childMessageKey = childSnapshot.key;
        childMessageKeyList.add(childMessageKey);
        resultList
            .add(snapMessages.snapshot.child(childMessageKeyList[i]).value);
      }
      final result = resultList[i];
      mList.add(Message.fromJson(Map<String, dynamic>.from(result)));
    }
    return mList;
  }

  void addPost(Post post) async {
    await _postRef.child(post.id).push().set(
          post.toJson(),
        );
  }

  Future<void> editPost(Post post) async {
    await _postRef.child(post.id).update(post.toJson());
  }

  Future<void> deletePost(Post post) async {
    await _postRef.child(post.id).remove();
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

  Future<void> deleteMessage(Message message) async {
    await _messageRef.child(message.id.toString()).remove();
  }
}

class MessageType {
  static const text = 0;
  static const image = 1;
}
