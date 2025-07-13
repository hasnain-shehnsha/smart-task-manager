import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/task_model.dart';

class FirebaseTaskDataSource {
  final _tasksCollection = FirebaseFirestore.instance.collection('tasks');

  Future<void> addTask(TaskModel task) async {
    print('addTask called with: ' + task.toMap().toString());
    await _tasksCollection.doc(task.id).set(task.toMap());
    print('addTask completed for: ' + task.id);
  }

  Future<void> updateTask(TaskModel task) async {
    await _tasksCollection.doc(task.id).update(task.toMap());
  }

  Future<void> deleteTask(String id) async {
    await _tasksCollection.doc(id).delete();
  }

  Future<List<TaskModel>> getTasks() async {
    final snapshot = await _tasksCollection.get();
    return snapshot.docs.map((doc) => TaskModel.fromMap(doc.data())).toList();
  }

  Stream<List<TaskModel>> watchTasks() {
    return _tasksCollection.snapshots().map(
      (snapshot) =>
          snapshot.docs.map((doc) => TaskModel.fromMap(doc.data())).toList(),
    );
  }
}
