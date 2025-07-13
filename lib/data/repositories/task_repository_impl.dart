import '../../domain/entities/task.dart';
import '../../domain/repositories/task_repository.dart';
import '../datasources/firebase_task_datasource.dart';
import '../datasources/sqlite_task_datasource.dart';
import '../models/task_model.dart';

class TaskRepositoryImpl implements TaskRepository {
  final FirebaseTaskDataSource firebaseDataSource;
  final SQLiteTaskDataSource sqliteDataSource;
  final bool isOnline;

  TaskRepositoryImpl({
    required this.firebaseDataSource,
    required this.sqliteDataSource,
    required this.isOnline,
  });

  @override
  Future<void> addTask(Task task) async {
    final model = TaskModel(
      id: task.id,
      title: task.title,
      description: task.description,
      deadline: task.deadline,
      isCompleted: task.isCompleted,
      priority: task.priority,
      createdBy: task.createdBy,
    );
    await sqliteDataSource.addTask(model);
    if (isOnline) {
      await firebaseDataSource.addTask(model);
    }
  }

  
  @override
  Future<void> updateTask(Task task) async {
    final model = TaskModel(
      id: task.id,
      title: task.title,
      description: task.description,
      deadline: task.deadline,
      isCompleted: task.isCompleted,
      priority: task.priority,
      createdBy: task.createdBy,
    );
    await sqliteDataSource.updateTask(model);
    if (isOnline) {
      await firebaseDataSource.updateTask(model);
    }
  }

  @override
  Future<void> deleteTask(String id) async {
    await sqliteDataSource.deleteTask(id);
    if (isOnline) {
      await firebaseDataSource.deleteTask(id);
    }
  }

  @override
  Future<List<Task>> getTasks() async {
    if (isOnline) {
      return await firebaseDataSource.getTasks();
    } else {
      return await sqliteDataSource.getTasks();
    }
  }

  @override
  Stream<List<Task>> watchTasks() {
    if (isOnline) {
      return firebaseDataSource.watchTasks();
    } else {
      return sqliteDataSource.watchTasks();
    }
  }

  @override
  Future<void> syncTasks() async {
    if (isOnline) {
      final localTasks = await sqliteDataSource.getTasks();
      for (final task in localTasks) {
        await firebaseDataSource.addTask(task);
      }
    }
  }
}
