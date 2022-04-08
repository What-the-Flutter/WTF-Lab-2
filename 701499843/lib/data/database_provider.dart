import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/chat.dart';
import '../models/event.dart';
import '../models/event_icon.dart';

class DatabaseProvider {
  Database? _database;
  final String chatsTable = 'chats';
  final String eventsTable = 'events';
  final String iconsTable = 'icons';

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await initDB();
    return _database!;
  }

  Future<Database> initDB() async {
    return await openDatabase(
      join(await getDatabasesPath(), 'chats_journal_database.db'),
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE $chatsTable(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, icon INTEGER, category TEXT);'
          'CREATE TABLE $eventsTable(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, category TEXT, '
          'description TEXT, isFavorite BOOL, isSelected BOOL, timeOfCreation TEXT, image TEXT);'
          'CREATE TABLE $iconsTable(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, icon INTEGER, isSelected BOOL);',
        );
        addValues();
      },
    );
  }

  void addValues() {
    addChats();
    addEvents();
    addIcons();
  }

  Future<void> updateChat(Chat chat) async {
    final db = await database;

    await db.update(
      chatsTable,
      chat.toMap(),
      where: 'category = ?',
      whereArgs: [chat.category],
    );
  }

  Future<void> updateEvent(Event event) async {
    final db = await database;

    await db.update(
      eventsTable,
      event.toMap(),
      where: 'id = ?',
      whereArgs: [
        event.id,
      ],
    );
  }

  Future<void> updateIcon(EventIcon icon) async {
    final db = await database;

    await db.update(
      iconsTable,
      icon.toMap(),
      where: 'icon = ?',
      whereArgs: [icon],
    );
  }

  Future<void> insertChat(Chat chat) async {
    final db = await database;

    await db.insert(
      chatsTable,
      chat.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> insertChats(List<Chat> chats) async {
    for (final element in chats) {
      insertChat(element);
    }
  }

  Future<void> removeChat(Chat chat) async {
    final db = await database;

    await db.delete(
      chatsTable,
      where: 'category = ?',
      whereArgs: [chat.category],
    );
  }

  void removeChats(List<Chat> chats) {
    for (final element in chats) {
      removeChat(element);
    }
  }

  Future<void> insertEvent(Event event) async {
    final db = await database;

    await db.insert(
      eventsTable,
      event.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> insertEvents(List<Event> events) async {
    for (final element in events) {
      insertEvent(element);
    }
  }

  Future<void> removeEvent(Event event) async {
    final db = await database;

    db.delete(
      eventsTable,
      where: 'category = ? and description = ?',
      whereArgs: [
        event.category,
        event.description,
      ],
    );
  }

  void removeEvents(List<Event> events) {
    for (final element in events) {
      removeEvent(element);
    }
  }

  Future<void> insertIcon(EventIcon icon) async {
    final db = await database;

    await db.insert(
      iconsTable,
      icon.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> insertIcons(List<EventIcon> icons) async {
    for (final element in icons) {
      insertIcon(element);
    }
  }

  Future<void> removeIcon(EventIcon icon) async {
    final db = await database;

    await db.delete(
      iconsTable,
      where: 'icon = ?',
      whereArgs: [icon],
    );
  }

  void removeIcons(List<EventIcon> icons) {
    for (final element in icons) {
      removeIcon(element);
    }
  }

  Future<List<Event>> getEvents() async {
    final db = await database;

    final List<Map<String, dynamic>> maps =
        await db.rawQuery('SELECT * from events order by timeOfCreation');

    return List.generate(
      maps.length,
      (index) {
        bool flagFavorite, flagSelected;
        if (maps[index]['isFavorite'] == 1) {
          flagFavorite = true;
        } else {
          flagFavorite = false;
        }
        if (maps[index]['isSelected'] == 1) {
          flagSelected = true;
        } else {
          flagSelected = false;
        }
        return Event(
          id: maps[index]['id'],
          description: maps[index]['description'],
          image: maps[index]['image'],
          isFavorite: flagFavorite,
          isSelected: flagSelected,
          category: maps[index]['category'],
          timeOfCreation: maps[index]['timeOfCreation'],
        );
      },
    );
  }

  Future<List<Chat>> getChats() async {
    final db = await database;

    final List<Map<String, dynamic>> maps = await db.query(chatsTable);

    return List.generate(
      maps.length,
      (index) {
        return Chat(
          id: maps[index]['id'],
          category: maps[index]['category'],
          icon: maps[index]['icon'],
        );
      },
    );
  }

  Future<List<EventIcon>> getIcons() async {
    final db = await database;

    final List<Map<String, dynamic>> maps = await db.query(iconsTable);

    return List.generate(
      maps.length,
      (i) {
        bool flag;
        if (maps[i]['isSelected'] == 1) {
          flag = true;
        } else {
          flag = false;
        }
        return EventIcon(
          id: maps[i]['id'],
          icon: maps[i]['icon'],
          isSelected: flag,
        );
      },
    );
  }

  void addChats() {
    insertChats(
      <Chat>[
        Chat(
          id: 0,
          category: 'Travel',
          icon: 12,
        ),
        Chat(
          id: 1,
          category: 'Family',
          icon: 13,
        ),
        Chat(
          id: 2,
          category: 'Sports',
          icon: 14,
        ),
      ],
    );
  }

  void addEvents() {
    insertEvents(
      <Event>[
        Event(
          id: 0,
          category: 'Travel',
          description: 'qqqq',
          isFavorite: false,
          isSelected: false,
          timeOfCreation:
              DateFormat('yyyy-MM-dd – kk:mm').format(DateTime.now()),
        ),
        Event(
          id: 1,
          category: 'Family',
          description: 'wwww',
          isFavorite: false,
          isSelected: false,
          timeOfCreation:
              DateFormat('yyyy-MM-dd – kk:mm').format(DateTime.now()),
        ),
        Event(
          id: 2,
          category: 'Sports',
          description: 'eeee',
          isFavorite: false,
          isSelected: false,
          timeOfCreation:
              DateFormat('yyyy-MM-dd – kk:mm').format(DateTime.now()),
        ),
      ],
    );
  }

  void addIcons() {
    insertIcons(
      List.generate(
        11,
        (index) => EventIcon(id: index, icon: index),
      ),
    );
  }
}
