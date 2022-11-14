import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class ChatsDataBaseProvider {
  Database? _database;

  Future<Database> get db async {
    if (_database != null) {
      return _database!;
    } else {
      _database = await _createDatabase();
      return _database!;
    }
  }

  Future<Database> _createDatabase() async {
    return openDatabase(
      join(await getDatabasesPath(), 'chats_database.db'),
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE chatsTable ('
              'chat_id INTEGER PRIMARY KEY AUTOINCREMENT, '
              'icon INTEGER, '
              'title TEXT, '
              'subtitle TEXT, '
              'is_selected INTEGER '
              ')',
        );
        await db.execute(
            '''
            CREATE TABLE messagesTable (
              message_id INTEGER PRIMARY KEY AUTOINCREMENT,
              text TEXT,
              sent_time TEXT,
              is_selected INTEGER,
              on_edit INTEGER,
              FK_chat_table INTEGER,
              FOREIGN KEY (FK_chat_table) REFERENCES chatsTable(chat_id)
            )
            '''
        );
      },
    );
  }
  Future _deleteDatabase() async {
    deleteDatabase(join(await getDatabasesPath(), 'chats_database.db'));
  }
}