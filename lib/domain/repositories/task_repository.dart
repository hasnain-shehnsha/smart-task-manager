import '../entities/task.dart';

abstract class TaskRepository {
  Future<void> addTask(Task task);
  Future<void> updateTask(Task task);
  Future<void> deleteTask(String id);
  Future<List<Task>> getTasks();
  Stream<List<Task>> watchTasks();
  Future<void> syncTasks();
}
