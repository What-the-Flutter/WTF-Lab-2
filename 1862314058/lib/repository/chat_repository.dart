import '../data/models/message.dart';
import '../data/models/post.dart';
import '../data/provider_db.dart';

class ChatRepository {
  final _dbProvider = DBProvider.instance;

  ChatRepository();

  Future<List<Post>> getAllPost() async {
    return await _dbProvider.getAllPosts();
  }

  Future<Post> addPost(Post post) async {
    return await _dbProvider.addPost(post);
  }

  Future<int> editPost(Post post) async {
    return await _dbProvider.editPost(post);
  }

  Future<void> deletePost(Post post) async {
    return await _dbProvider.deletePost(post);
  }

  Future<Message> addMessage(Message message) async {
    return await _dbProvider.addMessage(message);
  }

  Future<void> deleteMessage(Message message) async {
    return await _dbProvider.deleteMessage(message);
  }
}
