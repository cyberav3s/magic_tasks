// ignore_for_file: must_be_immutable
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:magic_tasks/features/task/models/enum.dart';

part 'task.g.dart';

@HiveType(typeId: 0)
class Task extends HiveObject with EquatableMixin {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final Tag tag;

  @HiveField(4)
  final Status status;

  @HiveField(5)
  final bool isCompleted;

  @HiveField(6)
  final DateTime dueDate;

  @HiveField(7)
  final DateTime createdAt;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.tag,
    required this.status,
    required this.dueDate,
    required this.isCompleted,
    required this.createdAt,
  });

  Task copyWith({
    String? id,
    String? title,
    String? description,
    Tag? tag,
    Status? status,
    bool? isCompleted,
    DateTime? dueDate,
    DateTime? createdAt,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      tag: tag ?? this.tag,
      status: status ?? this.status,
      dueDate: dueDate ?? this.dueDate,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    tag,
    isCompleted,
    dueDate,
    createdAt,
  ];
}
