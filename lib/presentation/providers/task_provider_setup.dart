import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/usecases/add_task.dart';
import '../../domain/usecases/update_task.dart';
import '../../domain/usecases/delete_task.dart';
import '../../domain/usecases/get_tasks.dart';
import '../../domain/usecases/watch_tasks.dart';
import '../../data/repositories/task_repository_impl.dart';
import '../../data/datasources/firebase_task_datasource.dart';
import '../../data/datasources/sqlite_task_datasource.dart';
import '../../core/network/network_info.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../../domain/repositories/task_repository.dart';

final taskRepositoryProvider = Provider<TaskRepository>((ref) {
  final firebase = FirebaseTaskDataSource();
  final sqlite = SQLiteTaskDataSource();
  // For demo, always online. Replace with actual network check if needed.
  return TaskRepositoryImpl(
    firebaseDataSource: firebase,
    sqliteDataSource: sqlite,
    isOnline: true,
  );
});

final addTaskProvider = Provider<AddTask>(
  (ref) => AddTask(ref.watch(taskRepositoryProvider)),
);
final updateTaskProvider = Provider<UpdateTask>(
  (ref) => UpdateTask(ref.watch(taskRepositoryProvider)),
);
final deleteTaskProvider = Provider<DeleteTask>(
  (ref) => DeleteTask(ref.watch(taskRepositoryProvider)),
);
final getTasksProvider = Provider<GetTasks>(
  (ref) => GetTasks(ref.watch(taskRepositoryProvider)),
);
final watchTasksProvider = Provider<WatchTasks>(
  (ref) => WatchTasks(ref.watch(taskRepositoryProvider)),
);
