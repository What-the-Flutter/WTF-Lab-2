import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../data/models/message.dart';
import '../data/models/post.dart';

class FirebaseRepository {
  final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref();
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  final User? user;

  FirebaseRepository({
    required this.user,
  });

  Future<List<Post>> getAllPosts() async {
    final posts = <Post>[];
    //final newPostKey = FirebaseDatabase.instance.ref().child('posts').get();
    final databasePost =
        await _databaseReference.child(user!.uid).child('posts').once();
    for (final child in databasePost.snapshot.children) {
      final map = child.value as Map<String, dynamic>;
      final addPost = Post.fromJson(map);
      posts.add(addPost);
    }
    return posts;
  }

  Future<List<Message>> getAllMessages(Post post) async {
    final messages = <Message>[];
    final databaseMessage = await _databaseReference
        .child(user!.uid)
        .child('posts')
        .child('messages')
        .once();
    for (final child in databaseMessage.snapshot.children) {
      final map = child.value as Map<String, dynamic>;
      final addMessage = Message.fromJson(map);
      messages.add(addMessage);
    }
    return messages;
  }

  Future<void> addPost(Post post) async {
    await _databaseReference
        .child(user!.uid)
        .child('posts')
        .child(post.id.toString())
        .set(
          post.toJson(),
        );
  }

  Future<void> editPost(Post post) async {
    await _databaseReference
        .child(user!.uid)
        .child('posts')
        .child(post.id.toString())
        .update(
          post.toJson(),
        );
  }

  Future<void> deletePost(Post post) async {
    await _databaseReference
        .child(user!.uid)
        .child('posts')
        .child(post.id.toString())
        .remove();
  }

  Future<void> addMessage(Message message) async {
    // final imagePath = message.textMessage;
    // File? file;
    // if (imagePath != null) {
    //   file = File(imagePath);
    // }
    // if (file != null) {
    //   await _firebaseStorage.ref('${user!.uid}/images').putFile(file);
    // }

    await _databaseReference
        .child(user!.uid)
        .child('posts')
        .child('messages')
        .child(message.id.toString())
        .set(
          message.toJson(),
        );
  }

  Future<void> editMessage(Message message) async {
    await _databaseReference
        .child(user!.uid)
        .child('posts')
        .child('messages')
        .child(message.id.toString())
        .update(
          message.toJson(),
        );
  }

  Future<void> deleteMessage(Message message) async {
    await _databaseReference
        .child(user!.uid)
        .child('posts')
        .child('messages/${message.id}')
        .remove();
  }
}

class MessageType {
  static const text = 0;
  static const image = 1;
}
