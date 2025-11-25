part of 'task_bloc.dart';

abstract class TaskEvent extends Equatable {
  const TaskEvent();

  @override
  List<Object?> get props => [];
}

class LoadTasks extends TaskEvent {}

class AddTask extends TaskEvent {
  final String title;
  final String description;
  final DateTime dueDate;
  final bool isCompleted;
  final Tag tag;

  const AddTask(
    this.dueDate,
    this.tag,
    this.isCompleted, {
    required this.title,
    required this.description,
  });

  @override
  List<Object?> get props => [title, description, tag, dueDate, isCompleted];
}

class UpdateTask extends TaskEvent {
  final Task task;

  const UpdateTask(this.task);

  @override
  List<Object?> get props => [task];
}

class ToggleTaskCompletion extends TaskEvent {
  final String taskId;

  const ToggleTaskCompletion(this.taskId);

  @override
  List<Object?> get props => [taskId];
}

class DeleteTask extends TaskEvent {
  final String taskId;

  const DeleteTask(this.taskId);

  @override
  List<Object?> get props => [taskId];
}

class ClearAllTasks extends TaskEvent {}
