import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

//if not exists
final String tableName = "Word";
// ignore: non_constant_identifier_names
final String Column_id = "ID";
// ignore: non_constant_identifier_names
final String Column_karsilik1 = "Karşılık1";
// ignore: non_constant_identifier_names
final String Column_karsilik2 = "Karşılık2";

// ignore: non_constant_identifier_names
final String Column_kelime = "Kelime";

class TaskModel {
  final String kelime;
  final String karsilik1;
  final String karsilik2;

  int id;

  TaskModel(
      {this.kelime, this.id, this.karsilik1, this.karsilik2});

  Map<String, dynamic> toMap() {
    return {
      Column_kelime: this.kelime,
      Column_karsilik1: this.karsilik1,
      Column_karsilik2: this.karsilik2,
    };
  }
}

class TodoHelper {
  Database db;

  TodoHelper() {
    initDatabase();
  }

  Future<void> initDatabase() async {
    db = await openDatabase(join(await getDatabasesPath(), "databse.db"),
        onCreate: (db, version) {
      return db.execute(
          "CREATE TABLE $tableName($Column_id INTEGER PRIMARY KEY AUTOINCREMENT,$Column_kelime TEXT, $Column_karsilik1 TEXT, $Column_karsilik2 TEXT)");
    }, version: 1);
  }

  Future<void> insertTask(TaskModel task) async {
    try {
      db.insert(tableName, task.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    } catch (_) {
      print(_);
    }
  }

  Future<void> deleteTask(int x) async {
    try {
      db.execute(
        'DELETE FROM $tableName WHERE $Column_id = ? ',
        [x],
      );
    } catch (_) {
      print(_);
    }
  }

  Future<List<TaskModel>> getAllTask() async {
    final List<Map<String, dynamic>> tasks = await db.query(tableName);

    return List.generate(tasks.length, (i) {
      return TaskModel(
        kelime: tasks[i][Column_kelime],
        karsilik1: tasks[i][Column_karsilik1],
        karsilik2: tasks[i][Column_karsilik2],

        id: tasks[i][Column_id],
      );
    });
  }
}
