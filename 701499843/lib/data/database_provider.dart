import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/chat.dart';
import '../models/event.dart';
import '../models/event_icon.dart';

class DatabaseProvider {
  static Database? _database;
  final String chatsTable = 'chats';
  final String eventsTable = 'events';
  final String iconsTable = 'icons';

  DatabaseProvider._();
  static final DatabaseProvider db = DatabaseProvider._();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await initDB();
    return _database!;
  }

  Future<Database> initDB() async {
    WidgetsFlutterBinding.ensureInitialized();
    return await openDatabase(
      join(await getDatabasesPath(), 'chats_journal_database.db'),
      version: 1,
      onCreate: (db, version) async {
        db.execute(
          'CREATE TABLE $chatsTable(icon INTEGER PRIMARY KEY NOT NULL, category TEXT);',
        );
        db.execute(
          'CREATE TABLE $eventsTable(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, category TEXT, '
          'description TEXT, isFavorite BOOL, isSelected BOOL, timeOfCreation TEXT, image TEXT); ',
        );

        db.execute(
          'CREATE TABLE $iconsTable(icon INTEGER PRIMARY KEY, isSelected BOOL);',
        );
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

  Future<void> updateEvent(Event previousEvent, Event newEvent) async {
    final db = await database;

    await db.update(
      eventsTable,
      newEvent.toMap(),
      where: 'category = ? and description = ?',
      whereArgs: [
        previousEvent.category,
        previousEvent.description,
      ],
    );
  }

  Future<void> updateIcon(EventIcon icon) async {
    final db = await database;

    await db.update(
      iconsTable,
      icon.toMap(),
      where: 'icon = ?',
      whereArgs: [icon.icon.icon!.codePoint],
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
    for (var element in chats) {
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
    for (var element in chats) {
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
    for (var element in events) {
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
    for (var element in events) {
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
    for (var element in icons) {
      insertIcon(element);
    }
  }

  Future<void> removeIcon(EventIcon icon) async {
    final db = await database;

    await db.delete(
      iconsTable,
      where: 'icon = ?',
      whereArgs: [icon.icon.icon!.codePoint],
    );
  }

  void removeIcons(List<EventIcon> icons) {
    for (var element in icons) {
      removeIcon(element);
    }
  }

  Future<List<Event>> getEvents() async {
    final db = await database;

    final List<Map<String, dynamic>> maps = await db.query(eventsTable);

    return List.generate(maps.length, (index) {
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
        description: maps[index]['description'],
        image: maps[index]['image'],
        isFavorite: flagFavorite,
        isSelected: flagSelected,
        category: maps[index]['category'],
      );
    });
  }

  Future<List<Chat>> getChats() async {
    final db = await database;

    final List<Map<String, dynamic>> maps = await db.query(chatsTable);

    return List.generate(
      maps.length,
      (index) {
        return Chat(
          category: maps[index]['category'],
          icon: Icon(
            IconData(maps[index]['icon'], fontFamily: 'MaterialIcons'),
          ),
        );
      },
    );
  }

  Future<List<EventIcon>> getIcons() async {
    final db = await database;

    final List<Map<String, dynamic>> maps = await db.query(iconsTable);

    return List.generate(maps.length, (i) {
      bool flag;
      if (maps[i]['isSelected'] == 1) {
        flag = true;
      } else {
        flag = false;
      }
      return EventIcon(
        icon: Icon(
          IconData(maps[i]['icon'], fontFamily: 'MaterialIcons'),
        ),
        isSelected: flag,
      );
    });
  }

  void addChats() {
    db.insertChats(
      <Chat>[
        Chat(
          category: 'Travel',
          icon: const Icon(Icons.flight_takeoff),
        ),
        Chat(
          category: 'Family',
          icon: const Icon(Icons.chair),
        ),
        Chat(
          category: 'Sports',
          icon: const Icon(Icons.sports_baseball),
        ),
      ],
    );
  }

  void addEvents() {
    db.insertEvents(<Event>[
      Event(
        category: 'Travel',
        description: 'qqqq',
        isFavorite: false,
        isSelected: false,
      ),
      Event(
        category: 'Family',
        description: 'wwww',
        isFavorite: false,
        isSelected: false,
      ),
      Event(
        category: 'Sports',
        description: 'eeee',
        isFavorite: false,
        isSelected: false,
      ),
    ]);
  }

  void addIcons() {
    db.insertIcons(
      <EventIcon>[
        EventIcon(
          icon: const Icon(
            Icons.ac_unit,
          ),
        ),
        EventIcon(
          icon: const Icon(
            Icons.access_alarm,
          ),
        ),
        EventIcon(
          icon: const Icon(
            Icons.access_time,
          ),
        ),
        EventIcon(
          icon: const Icon(
            Icons.accessibility,
          ),
        ),
        EventIcon(
          icon: const Icon(
            Icons.baby_changing_station,
          ),
        ),
        EventIcon(
          icon: const Icon(
            Icons.cabin,
          ),
        ),
        EventIcon(
          icon: const Icon(
            Icons.qr_code,
          ),
        ),
        EventIcon(
          icon: const Icon(
            Icons.wallet_giftcard,
          ),
        ),
        EventIcon(
          icon: const Icon(
            Icons.e_mobiledata,
          ),
        ),
        EventIcon(
          icon: const Icon(
            Icons.r_mobiledata,
          ),
        ),
        EventIcon(
          icon: const Icon(
            Icons.tab,
          ),
        ),
        EventIcon(
          icon: const Icon(
            Icons.yard,
          ),
        ),
      ],
    );
  }
}
