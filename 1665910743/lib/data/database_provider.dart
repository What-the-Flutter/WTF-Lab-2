import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/event.dart';
import '../models/event_category.dart';

class DataBase {
  static Database? _database;
  final String categoryTable = 'category';
  final String eventsTable = 'events';

  DataBase._();
  static final DataBase db = DataBase._();

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
      join(await getDatabasesPath(), 'journal_db.db'),
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE $categoryTable(icon INTEGER, title TEXT, pined BOOL)',
        );
        await db.execute(
          'CREATE TABLE $eventsTable(imagePath TEXT, icon INTEGER, title TEXT, '
          'date TEXT, favorite BOOL, isSelected BOOL,categoryIndex INTEGER, categoryTitle TEXT); ',
        );
      },
    );
  }

  Future<void> addCategory(EventCategory event) async {
    final db = await database;

    await db.insert(
      categoryTable,
      event.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> removeCategory(String title) async {
    final db = await database;

    await db.delete(
      eventsTable,
      where: 'categoryTitle = ?',
      whereArgs: [title],
    );

    await db.delete(
      categoryTable,
      where: 'title = ?',
      whereArgs: [title],
    );
  }

  Future<void> renameCategory(String title, String newTitle) async {
    final db = await database;

    await db.update(
      eventsTable,
      {'categoryTitle': newTitle},
      where: 'categoryTitle = ?',
      whereArgs: [title],
    );

    await db.update(
      categoryTable,
      {'title': newTitle},
      where: 'title = ?',
      whereArgs: [title],
    );
  }

  Future<void> pinCategory(String title) async {
    final db = await database;
    await db.update(
      categoryTable,
      {'pined': 1},
      where: 'title = ?',
      whereArgs: [title],
    );
  }

  Future<void> unpinCategory(String title) async {
    final db = await database;
    await db.update(
      categoryTable,
      {'pined': 0},
      where: 'title = ?',
      whereArgs: [title],
    );
  }

  Future<void> addEvent(Event event) async {
    final db = await database;

    await db.insert(
      eventsTable,
      event.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> removeEvent(String title) async {
    final db = await database;

    await db.delete(
      eventsTable,
      where: 'title = ?',
      whereArgs: [title],
    );
  }

  Future<void> renameEvent(String title, String newTitle) async {
    final db = await database;

    await db.update(
      eventsTable,
      {'title': newTitle},
      where: 'title = ?',
      whereArgs: [title],
    );
  }

  Future<void> bookmarkEvent(String title, bool isFavorite) async {
    final db = await database;

    await db.update(
      eventsTable,
      {'favorite': isFavorite ? 0 : 1},
      where: 'title = ?',
      whereArgs: [title],
    );
  }

  Future<void> moveEvent(String title, String newCategory) async {
    final db = await database;

    await db.update(
      eventsTable,
      {'categoryTitle': newCategory},
      where: 'title = ?',
      whereArgs: [title],
    );
  }

  Future<List<Event>> getEventList(String title) async {
    final db = await database;
//
    final List<Map<String, dynamic>> events = await db.query(
      eventsTable,
      where: 'categoryTitle = ?',
      whereArgs: [title],
      orderBy: 'date',
    );

    return List.generate(
      events.length,
      (i) {
        final String imagePath = events[i]['imagePath'];
        return Event(
          image: imagePath.length > 1 ? File(imagePath) : null,
          iconCode: events[i]['icon'],
          title: events[i]['title'],
          date: DateTime.parse(events[i]['date']),
          favorite: events[i]['favorite'] == 0 ? false : true,
          categoryIndex: events[i]['categoryIndex'],
          categoryTitle: events[i]['categoryTitle'],
        );
      },
    );
  }

  Future<List<EventCategory>> getCategoryList() async {
    final db = await database;

    final List<Map<String, dynamic>> maps = await db.query(
      categoryTable,
      orderBy: 'title',
    );

    return List.generate(
      maps.length,
      (i) {
        return EventCategory(
          title: maps[i]['title'],
          icon: Icon(
            IconData(maps[i]['icon'], fontFamily: 'MaterialIcons'),
          ),
          pined: maps[i]['pined'] == 0 ? false : true,
        );
      },
    );
  }

  void delete() async {
    final db = await database;

    await deleteDatabase(db.path);
  }
}
