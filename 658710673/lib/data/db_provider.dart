import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/category.dart';
import '../models/event.dart';

class DBProvider {
  static Database? _database;
  static const String categoryTable = 'categories';
  static const String eventsTable = 'events';

  DBProvider._();

  static final DBProvider db = DBProvider._();

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
      join(await getDatabasesPath(), 'chat_journal_db.db'),
      version: 1,
      onCreate: (db, version) async {
        db.execute(
          'CREATE TABLE $categoryTable(${CategoryFields.id} INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, '
          '${CategoryFields.title} TEXT, ${CategoryFields.icon} INTEGER, ${CategoryFields.timeOfCreation} TEXT);',
        );
        db.execute(
          'CREATE TABLE $eventsTable(${EventFields.id} INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, '
          '${EventFields.categoryId} INTEGER, ${EventFields.description} TEXT, '
          '${EventFields.isBookmarked} BOOL, ${EventFields.timeOfCreation} TEXT, '
          '${EventFields.attachment} TEXT, ${EventFields.sectionIcon} INTEGER, ${EventFields.sectionTitle} TEXT); ',
        );
      },
    );
  }

  Future<Category> addCategory(Category category) async {
    final db = await database;

    final id = await db.insert(
      categoryTable,
      category.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    return category.copyWith(id: id);
  }

  Future<void> deleteCategory(Category category) async {
    final db = await database;

    await db.delete(
      eventsTable,
      where: '${EventFields.categoryId} = ?',
      whereArgs: [category.id],
    );

    await db.delete(
      categoryTable,
      where: '${CategoryFields.id} = ?',
      whereArgs: [category.id],
    );
  }

  Future<void> updateCategory(Category category) async {
    final db = await database;

    await db.update(
      categoryTable,
      category.toMap(),
      where: '${CategoryFields.id} = ?',
      whereArgs: [category.id],
    );
  }

  Future<List<Category>> getAllCategories() async {
    final db = await database;

    final List<Map<String, dynamic>> maps = await db.query(
      categoryTable,
      orderBy: CategoryFields.id,
    );

    return List.generate(
      maps.length,
      (i) {
        return Category.fromDB(
          id: maps[i][CategoryFields.id],
          title: maps[i][CategoryFields.title],
          icon: Icon(
            IconData(maps[i][CategoryFields.icon], fontFamily: 'MaterialIcons'),
          ),
          timeOfCreation: DateTime.parse(maps[i][CategoryFields.timeOfCreation]),
        );
      },
    );
  }

  Future<Event> addEvent(Event event) async {
    final db = await database;

    final id = await db.insert(
      eventsTable,
      event.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    return event.copyWith(id: id);
  }

  Future<void> deleteEvent(Event event) async {
    final id = event.id;
    final db = await database;

    await db.delete(
      eventsTable,
      where: '${EventFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future<void> updateEvent(Event event) async {
    final db = await database;

    await db.update(
      eventsTable,
      event.toMap(),
      where: '${EventFields.id} = ?',
      whereArgs: [event.id],
    );
  }

  Future<List<Event>> getAllCategoryEvents(Category category) async {
    final db = await database;

    final List<Map<String, dynamic>> maps = await db.query(
      eventsTable,
      where: '${EventFields.categoryId} = ?',
      whereArgs: [category.id],
      orderBy: 'id',
    );

    return List.generate(
      maps.length,
      (i) {
        return Event.fromDB(
          maps[i][EventFields.description],
          maps[i][EventFields.categoryId],
          id: maps[i][EventFields.id],
          timeOfCreation: DateTime.parse(maps[i][EventFields.timeOfCreation]),
          attachment: maps[i][EventFields.attachment],
          isBookmarked: maps[i][EventFields.isBookmarked] == 1 ? true : false,
          sectionIcon: maps[i][EventFields.sectionIcon],
          sectionTitle: maps[i][EventFields.sectionTitle],
        );
      },
    );
  }

  Future<void> deleteDB() async {
    final db = await database;

    await deleteDatabase(db.path);
  }
}
