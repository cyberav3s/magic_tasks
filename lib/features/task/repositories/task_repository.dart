import 'package:hive/hive.dart';
import 'package:magic_tasks/features/task/models/task.dart';

class TaskRepository {
  static const String _boxName = 'tasks';

  Box<Task> get _box => Hive.box<Task>(_boxName);

  List<Task> getTasks() {
    return _box.values.toList();
  }

  Future<void> addTask(Task task) async {
    await _box.put(task.id, task);
  }

  Future<void> updateTask(Task task) async {
    await _box.put(task.id, task);
  }

  Future<void> deleteTask(String id) async {
    await _box.delete(id);
  }

  Task? getTaskById(String id) {
    return _box.get(id);
  }

  Future<void> clearAllTasks() async {
    await _box.clear();
  }
}
