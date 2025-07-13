import '../../domain/entities/task.dart';

class TaskModel extends Task {
  TaskModel({
    required String id,
    required String title,
    required String description,
    required DateTime deadline,
    required bool isCompleted,
    required int priority,
    required String createdBy,
  }) : super(
         id: id,
         title: title,
         description: description,
         deadline: deadline,
         isCompleted: isCompleted,
         priority: priority,
         createdBy: createdBy,
       );

  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      deadline: DateTime.parse(map['deadline']),
      isCompleted: map['isCompleted'] ?? false,
      priority: map['priority'] ?? 0,
      createdBy: map['createdBy'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'deadline': deadline.toIso8601String(),
      'isCompleted': isCompleted,
      'priority': priority,
      'createdBy': createdBy,
    };
  }
}
