import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'models/app_state.dart';
import 'models/event.dart';
import 'models/message.dart';

class DatabaseProvider {
  static final DatabaseProvider instance = DatabaseProvider._init();
  static Database? _database;

  DatabaseProvider._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase('add_database.db');
    return _database!;
  }

  Future<Database> _initDatabase(String dbName) async {
    var dbPath = await getDatabasesPath();
    var path = join(dbPath, dbName);
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute(
        'CREATE TABLE IF NOT EXISTS app_state (id INTEGER PRIMARY KEY, chatEventId INTEGER)');
    await db.execute(
        'CREATE TABLE IF NOT EXISTS event (id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT NOT NULL, subtitle TEXT NOT NULL, isFavorite BOOLEAN NOT NULL, isComplete BOOLEAN NOT NULL, iconData INTEGER NOT NULL)');
    await db.execute(
        'CREATE TABLE IF NOT EXISTS message (id INTEGER PRIMARY KEY AUTOINCREMENT, eventId INTEGER NOT NULL, text TEXT NOT NULL, date INTEGER NOT NULL, FOREIGN KEY (eventId) REFERENCES event(id) ON UPDATE CASCADE ON DELETE CASCADE)');
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }

  Future<Event> createEvent(Event event) async {
    final db = await instance.database;
    final id = await db.insert('event', event.toMap());

    return event.copyWith(id: id);
  }

  Future<Message> createMessage(Message message) async {
    final db = await instance.database;
    final id = await db.insert('message', message.toMap());

    return message.copyWith(id: id);
  }

  Future<AppState> createAppState(AppState appState) async {
    final db = await instance.database;
    final id = await db.insert('app_state', appState.toMap());

    return appState.copyWith(id: id);
  }

  Future<Event> readEvent(int id) async {
    final db = await instance.database;
    final maps = await db.query(
      'event',
      columns: [
        'id',
        'title',
        'subtitle',
        'isFavorite',
        'isComplete',
        'iconData',
      ],
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Event.fromMap(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<Message> readMessage(int id) async {
    final db = await instance.database;
    final maps = await db.query(
      'message',
      columns: [
        'id',
        'eventId',
        'text',
        'date',
      ],
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Message.fromMap(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<AppState> readAppState() async {
    final db = await instance.database;
    final maps = await db.query(
      'app_state',
      columns: [
        'id',
        'chatEventId',
      ],
    );

    if (maps.isNotEmpty) {
      return AppState.fromMap(maps.first);
    } else {
      throw Exception('App state not found');
    }
  }

  Future<List<Event>> readEvents() async {
    final db = await instance.database;
    final maps = await db.query('event');

    if (maps.isNotEmpty) {
      return List<Event>.generate(
          maps.length, (index) => Event.fromMap(maps[index]));
    } else {
      return <Event>[];
    }
  }

  Future<List<Message>> readMessages(int eventId) async {
    final db = await instance.database;
    final maps = await db.query(
      'message',
      where: 'eventId = ?',
      whereArgs: [eventId],
    );

    if (maps.isNotEmpty) {
      var list = List<Message>.generate(
          maps.length, (index) => Message.fromMap(maps[index]));
      return List<Message>.from(list.reversed);
    } else {
      return <Message>[];
    }
  }

  Future<int> updateEvent(Event event) async {
    final db = await instance.database;

    return await db.update(
      'event',
      event.toMap(),
      where: 'id = ?',
      whereArgs: [event.id],
    );
  }

  Future<int> updateMessage(Message message) async {
    final db = await instance.database;

    return await db.update(
      'message',
      message.toMap(),
      where: 'id = ?',
      whereArgs: [message.id],
    );
  }

  Future<int> updateAppState(AppState appState) async {
    final db = await instance.database;

    return await db.update(
      'app_state',
      appState.toMap(),
      where: 'id = ?',
      whereArgs: [appState.id],
    );
  }

  Future<int> deleteEvent(int id) async {
    final db = await instance.database;

    return await db.delete(
      'event',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteMessage(int id) async {
    final db = await instance.database;

    return await db.delete(
      'message',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
