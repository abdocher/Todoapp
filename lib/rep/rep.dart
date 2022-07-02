
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:todoapp/rep/database.dart';
import 'package:todoapp/rep/models/alarms.dart';
import 'package:todoapp/rep/models/category.dart';
import 'package:todoapp/rep/models/todo.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;

Future<void> insertObject(dynamic object, String table) async {
  final db = await DatabaseCon().setDatabase();
  await db.insert(
    table,
    object.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}

Future<List<Category>> allCategorys(String table) async {
  final db = await DatabaseCon().setDatabase();
  final List<Map<String, dynamic>> maps = await db.query(table);
  return List.generate(maps.length, (i) {
    return Category(
      maps[i]['id'],
      maps[i]['name'],
      maps[i]['description'],
    );
  });
}

Future<List<Todo>> allTodos(String categoryName) async {
  final db = await DatabaseCon().setDatabase();
  final List<Map<String, dynamic>> maps; 
  if(categoryName == 'All todos'){
  maps = await db.query('todo');
  }
  else{
    maps = await db.rawQuery('SELECT * FROM todo WHERE categoryName = ?',[categoryName]);
  }
  return List.generate(maps.length, (i) {
    return Todo(
      maps[i]['id'],
      maps[i]['title'],
      maps[i]['date'],
      maps[i]['time'],
      maps[i]['categoryName'],
      maps[i]['isDone'],
    );
  });
}

Future<void> updateTable(dynamic object, String table) async {
  final db = await DatabaseCon().setDatabase();
  await db.update(
    table,
    object.toMap(),
    where: 'id = ?',
    whereArgs: [object.id],
  );
}

Future<void> deleteRecord(int id, String table) async {
  final db = await DatabaseCon().setDatabase();
  await db.delete(
    table,
    where: 'id = ?',
    whereArgs: [id],
  );
}

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
Future setAlarm(String title, Alarm alarm, int id) async {
  tz.initializeTimeZones();

  AndroidInitializationSettings andInitialSettings =
      const AndroidInitializationSettings('baseline_add_alert_black_36dp');
  await flutterLocalNotificationsPlugin.initialize(InitializationSettings(
    android: andInitialSettings,
  ));
  const notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
          'your channel id', 'your channel name',
          channelDescription: 'your channel description'));
  DateTime date = DateTime.parse(alarm.date + ' '+alarm.time);
  await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      'time is up to do your task',
      tz.TZDateTime.from(date, tz.local),
      notificationDetails,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime);
}

Future deleteAlarm(int id) async {
  flutterLocalNotificationsPlugin.cancel(id);
}
