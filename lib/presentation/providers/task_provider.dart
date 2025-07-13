import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/task.dart';
import 'task_provider_setup.dart';

final taskListProvider = StreamProvider<List<Task>>((ref) {
  final watchTasks = ref.watch(watchTasksProvider);
  return watchTasks().asBroadcastStream();
});

final taskFilterProvider = StateProvider<String>((ref) => 'All');
final taskSortProvider = StateProvider<String>((ref) => 'Upcoming');

final filteredSortedTaskListProvider = Provider<AsyncValue<List<Task>>>((ref) {
  final filter = ref.watch(taskFilterProvider);
  final sort = ref.watch(taskSortProvider);
  final taskListAsync = ref.watch(taskListProvider);
  return taskListAsync.whenData((tasks) {
    var filtered = tasks;
    if (filter == 'Completed') {
      filtered = filtered.where((t) => t.isCompleted).toList();
    } else if (filter == 'Pending') {
      filtered = filtered.where((t) => !t.isCompleted).toList();
    }
    if (sort == 'Latest') {
      filtered.sort((a, b) => b.deadline.compareTo(a.deadline));
    } else {
      filtered.sort((a, b) => a.deadline.compareTo(b.deadline));
    }
    return filtered;
  });
});
