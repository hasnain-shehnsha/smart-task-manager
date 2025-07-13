import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/task_model.dart';

class SQLiteTaskDataSource {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'tasks.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE tasks(
            id TEXT PRIMARY KEY,
            title TEXT,
            description TEXT,
            deadline TEXT,
            isCompleted INTEGER,
            priority INTEGER,
            createdBy TEXT
          )
        ''');
      },
    );
  }

  Future<void> addTask(TaskModel task) async {
    final db = await database;
    await db.insert(
      'tasks',
      task.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateTask(TaskModel task) async {
    final db = await database;
    await db.update(
      'tasks',
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  Future<void> deleteTask(String id) async {
    final db = await database;
    await db.delete('tasks', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<TaskModel>> getTasks() async {
    final db = await database;
    final maps = await db.query('tasks');
    return maps.map((map) => TaskModel.fromMap(map)).toList();
  }

  Stream<List<TaskModel>> watchTasks() async* {
    while (true) {
      await Future.delayed(Duration(seconds: 1));
      yield await getTasks();
    }
  }
}
