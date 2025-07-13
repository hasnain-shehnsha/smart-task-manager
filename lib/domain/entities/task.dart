class Task {
  final String id;
  final String title;
  final String description;
  final DateTime deadline;
  final bool isCompleted;
  final int priority;
  final String createdBy;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.deadline,
    required this.isCompleted,
    required this.priority,
    required this.createdBy,
  });
}
