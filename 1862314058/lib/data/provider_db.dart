import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'models/message.dart';
import 'models/post.dart';

class DBProvider {
  static final DBProvider instance = DBProvider._();

  static Database? _database;

  DBProvider._();

  static const String postTable = 'posts';
  static const String messageTable = 'messages';

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('chatjournal.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    final idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    final textType = 'TEXT';
    final boolType = 'BOOL';

    await db.execute('''
    CREATE TABLE $postTable (
    ${PostFields.id} $idType,
    ${PostFields.title} $textType,
    ${PostFields.createPostTime} $textType
    )
    
    
    ''');

    await db.execute('''
    CREATE TABLE $messageTable (
    ${MessageFields.id} $idType,
    ${MessageFields.textMessage} $textType,
    ${MessageFields.createMessageTime} $textType,
    ${MessageFields.typeMessage} $textType,
    ${MessageFields.isSelectedMessage} $boolType
    )
    ''');
  }

  Future<Post> addPost(Post post) async {
    final db = await instance.database;
    final id = await db.insert(
      postTable,
      post.toJson(),
    );
    return post.copyWith(id: id);
  }

  Future<int> editPost(Post post) async {
    final db = await instance.database;
    return db.update(
      postTable,
      post.toJson(),
      where: '${PostFields.id} = ?',
      whereArgs: [post.id],
    );
  }

  Future<void> deletePost(Post post) async {
    final db = await instance.database;
    await db.delete(
      postTable,
      where: '${PostFields.id} = ?',
      whereArgs: [post.id],
    );
    await db.delete(
      messageTable,
      where: '${MessageFields.id} = ?',
      whereArgs: [post.id],
    );
  }

  Future<List<Post>> getAllPosts() async {
    final db = await instance.database;

    final List<Map<String, dynamic>> maps = await db.query(
      postTable,
      orderBy: PostFields.createPostTime,
    );
    return maps.map(Post.fromJson).toList();
  }

  Future<List<Message>> getAllMessages() async {
    final db = await instance.database;

    final List<Map<String, dynamic>> maps = await db.query(
      messageTable,
      orderBy: MessageFields.createMessageTime,
    );
    return maps.map(Message.fromJson).toList();
  }

  Future<Message> addMessage(Message message) async {
    final db = await instance.database;
    final id = await db.insert(
      messageTable,
      message.toJson(),
    );
    return message.copyWith(id: id);
  }

  Future<void> deleteMessage(Message message) async {
    final db = await instance.database;
    await db.delete(
      messageTable,
      where: '${MessageFields.id} = ?',
      whereArgs: [message.id],
    );
  }

  Future<int> editMessage(Message message) async {
    final db = await instance.database;
    return db.update(
      messageTable,
      message.toJson(),
      where: '${MessageFields.id} = ?',
      whereArgs: [message.id],
    );
  }

  Future closeDB() async {
    final db = await instance.database;
    db.close();
  }
}
