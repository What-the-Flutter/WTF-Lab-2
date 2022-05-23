import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'package:diploma/homePage/models/event.dart';
import 'package:diploma/homePage/models/event_holder.dart';

class DBContext {
  static const String _eventsTable = 'events';
  static const String _eventHoldersTable = 'eventholders';

  static Database? _database;

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
      join(await getDatabasesPath(), 'diploma.db'),
      version: 1,
      onCreate: (db, version) async {
        db.execute(
          'CREATE TABLE $_eventHoldersTable(eventholder_id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, '
          'title TEXT, iconIndex INTEGER);',
        );
        db.execute(
          'CREATE TABLE $_eventsTable(event_id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, '
          'eventholder_id INTEGER NOT NULL, '
          'text TEXT, iconIndex INTEGER, '
          'FOREIGN KEY (eventholder_id) '
          'REFERENCES eventholders (eventholder_id) ON UPDATE CASCADE ON DELETE CASCADE);',
        );
      },
    );
  }

  ///CRUD operations with Entities:

  //EventHolder:
  Future<void> addEventHolder(EventHolder eventHolder) async {
    final db = await database;

    await db.insert(
      _eventHoldersTable,
      eventHolder.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<EventHolder> getEventHolder(int eventHolderId) async {
    final db = await database;

    final List<Map<String, dynamic>> maps = await db.query(
      _eventHoldersTable,
      where: 'eventholder_id = ?',
      whereArgs: [eventHolderId],
    );
    assert(maps.isNotEmpty);
    return EventHolder.fromMap(maps.first);
  }

  Future<void> deleteEventHolder(int eventHolderId) async {
    final db = await database;

    await db.delete(
      _eventHoldersTable,
      where: 'eventholder_id = ?',
      whereArgs: [eventHolderId],
    );
  }

  Future<void> updateEventHolder(EventHolder eventHolder) async {
    final db = await database;

    await db.update(
      _eventHoldersTable,
      eventHolder.toMap(),
      where: 'eventholder_id = ?',
      whereArgs: [eventHolder.eventholderId],
    );
  }

  Future<List<EventHolder>> getAllEventHolders([int exceptId = -1]) async {
    final db = await database;

    final List<Map<String, dynamic>> maps;
    if(exceptId == -1){
      maps = await db.query(
        _eventHoldersTable,
        orderBy: 'eventholder_id',
      );
    }
    else{
      maps = await db.query(
        _eventHoldersTable,
        orderBy: 'eventholder_id',
        where: 'eventholder_id != ?',
        whereArgs: [exceptId],
      );
    }

    if(maps.isEmpty){
      return [];
    }
    return List.generate(
      maps.length,
          (i) {
        return EventHolder.fromMap(maps[i]);
      },
    );
  }

  //Events:
  Future<void> addEvent(Event event) async {
    final db = await database;

    await db.insert(
      _eventsTable,
      event.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> deleteEvent(int eventId) async {
    final db = await database;

    await db.delete(
      _eventsTable,
      where: 'event_id = ?',
      whereArgs: [eventId],
    );
  }

  Future<void> updateEvent(Event event) async {
    final db = await database;

    await db.update(
      _eventsTable,
      event.toMap(),
      where: 'event_id = ?',
      whereArgs: [event.eventId],
    );
  }

  Future<List<Event>> getAllEventsForEventHolder(int eventHolderId) async {
    final db = await database;

    final List<Map<String, dynamic>> maps = await db.query(
      _eventsTable,
      orderBy: 'event_id',
      where: 'eventholder_id = ?',
      whereArgs: [eventHolderId],
    );

    if(maps.isEmpty){
      return [];
    }
    return List.generate(
      maps.length,
          (i) {
        return Event.fromMap(maps[i]);
      },
    );
  }
}
