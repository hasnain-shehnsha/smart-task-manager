import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/task_provider.dart';
import '../providers/auth_provider.dart';
import '../providers/network_provider.dart';
import 'task_edit_screen.dart';

class TaskListScreen extends ConsumerWidget {
  const TaskListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filterOptions = ['All', 'Completed', 'Pending'];
    final sortOptions = ['Latest', 'Upcoming'];
    final selectedFilter = ref.watch(taskFilterProvider);
    final selectedSort = ref.watch(taskSortProvider);
    final taskListAsync = ref.watch(filteredSortedTaskListProvider);
    final isConnectedAsync = ref.watch(isConnectedProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasks'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => ref.read(authProvider.notifier).signOut(),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4),
          child: isConnectedAsync.when(
            data:
                (connected) => Container(
                  height: 4,
                  color: connected ? Colors.green : Colors.red,
                ),
            loading: () => const LinearProgressIndicator(minHeight: 4),
            error: (_, __) => Container(height: 4, color: Colors.grey),
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFe0eafc), Color(0xFFcfdef3)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 12.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  DropdownButton<String>(
                    value: selectedFilter,
                    borderRadius: BorderRadius.circular(16),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey,
                    ),
                    items:
                        filterOptions
                            .map(
                              (f) => DropdownMenuItem(value: f, child: Text(f)),
                            )
                            .toList(),
                    onChanged: (val) {
                      if (val != null) {
                        ref.read(taskFilterProvider.notifier).state = val;
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text('Filter: $val')));
                      }
                    },
                  ),
                  DropdownButton<String>(
                    value: selectedSort,
                    borderRadius: BorderRadius.circular(16),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey,
                    ),
                    items:
                        sortOptions
                            .map(
                              (s) => DropdownMenuItem(value: s, child: Text(s)),
                            )
                            .toList(),
                    onChanged: (val) {
                      if (val != null) {
                        ref.read(taskSortProvider.notifier).state = val;
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text('Sort: $val')));
                      }
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: taskListAsync.when(
                data:
                    (tasks) =>
                        tasks.isEmpty
                            ? const Center(
                              child: Text(
                                'No tasks yet!',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.blueGrey,
                                ),
                              ),
                            )
                            : ListView.separated(
                              padding: const EdgeInsets.all(16),
                              itemCount: tasks.length,
                              separatorBuilder:
                                  (_, __) => const SizedBox(height: 12),
                              itemBuilder: (context, index) {
                                final task = tasks[index];
                                return Card(
                                  elevation: 4,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: ListTile(
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 12,
                                    ),
                                    leading: CircleAvatar(
                                      backgroundColor:
                                          task.isCompleted
                                              ? Colors.green
                                              : Colors.blue,
                                      child: Icon(
                                        task.isCompleted
                                            ? Icons.check
                                            : Icons.pending,
                                        color: Colors.white,
                                      ),
                                    ),
                                    title: Text(
                                      task.title,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        decoration:
                                            task.isCompleted
                                                ? TextDecoration.lineThrough
                                                : null,
                                      ),
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          task.description,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 4),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.calendar_today,
                                              size: 16,
                                              color: Colors.blueGrey.shade300,
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              'Due: ${task.deadline.toLocal().toString().split(' ')[0]}',
                                              style: const TextStyle(
                                                fontSize: 12,
                                                color: Colors.blueGrey,
                                              ),
                                            ),
                                            const SizedBox(width: 12),
                                            Icon(
                                              Icons.flag,
                                              size: 16,
                                              color: Colors.orange.shade300,
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              'Priority: ${task.priority}',
                                              style: const TextStyle(
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    trailing: Icon(
                                      task.isCompleted
                                          ? Icons.check_circle
                                          : Icons.radio_button_unchecked,
                                      color:
                                          task.isCompleted
                                              ? Colors.green
                                              : Colors.blueGrey,
                                    ),
                                    onTap: () async {
                                      final result = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (_) => TaskEditScreen(task: task),
                                        ),
                                      );
                                      if (result == 'updated') {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text('Task updated!'),
                                          ),
                                        );
                                      } else if (result == 'deleted') {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text('Task deleted!'),
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                );
                              },
                            ),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(child: Text('Error: $e')),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const TaskEditScreen()),
          );
          if (result == 'added') {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('Task added!')));
          }
        },
        icon: const Icon(Icons.add),
        label: const Text('Add Task'),
        backgroundColor: Colors.blue,
      ),
    );
  }
}
