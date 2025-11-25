import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:magic_tasks/features/task/models/enum.dart';
import 'package:magic_tasks/features/task/models/task.dart';
import 'package:magic_tasks/features/task/repositories/task_repository.dart';

part 'task_event.dart';
part 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final TaskRepository repository;

  TaskBloc(this.repository) : super(TaskInitial()) {
    on<LoadTasks>(_onLoadTasks);
    on<AddTask>(_onAddTask);
    on<UpdateTask>(_onUpdateTask);
    on<ToggleTaskCompletion>(_onToggleTaskCompletion);
    on<DeleteTask>(_onDeleteTask);
    on<ClearAllTasks>(_onClearAllTasks);
  }

  void _onLoadTasks(LoadTasks event, Emitter<TaskState> emit) async {
    try {
      emit(TaskLoading());
      final tasks = repository.getTasks();
      emit(TaskLoaded(tasks));
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  void _onAddTask(AddTask event, Emitter<TaskState> emit) async {
    try {
      final task = Task(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: event.title,
        description: event.description,
        status: Status.pending,
        tag: Tag.habit,
        dueDate: event.dueDate,
        isCompleted: event.isCompleted,
        createdAt: DateTime.now(),
      );
      await repository.addTask(task);
      final tasks = repository.getTasks();
      emit(TaskLoaded(tasks));
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  void _onUpdateTask(UpdateTask event, Emitter<TaskState> emit) async {
    try {
      await repository.updateTask(event.task);
      final tasks = repository.getTasks();
      emit(TaskLoaded(tasks));
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  void _onToggleTaskCompletion(
      ToggleTaskCompletion event, Emitter<TaskState> emit) async {
    try {
      final task = repository.getTaskById(event.taskId);
      if (task != null) {
        final updatedTask = task.copyWith(status: Status.completed);
        await repository.updateTask(updatedTask);
        final tasks = repository.getTasks();
        emit(TaskLoaded(tasks));
      }
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  void _onDeleteTask(DeleteTask event, Emitter<TaskState> emit) async {
    try {
      await repository.deleteTask(event.taskId);
      final tasks = repository.getTasks();
      emit(TaskLoaded(tasks));
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  void _onClearAllTasks(ClearAllTasks event, Emitter<TaskState> emit) async {
    try {
      await repository.clearAllTasks();
      emit(const TaskLoaded([]));
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }
}