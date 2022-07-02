import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseCon {
  setDatabase() async {
    final database = openDatabase(
      join(await getDatabasesPath(), 'todo_database.db'),
      onCreate: (db, version) async {
        await db.execute(
            'CREATE TABLE category(id INTEGER PRIMARY KEY autoincrement, name TEXT , description TEXT)');
        await db.execute(
            ' CREATE TABLE todo(id INTEGER PRIMARY KEY autoincrement, title TEXT , date TEXT, time TEXT, categoryName TEXT,isDone INTEGER)');
      },
      version: 1,
    );
    return database;
  }
}
