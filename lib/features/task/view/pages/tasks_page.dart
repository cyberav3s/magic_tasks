import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:magic_tasks/core/constants/app_colors.dart';
import 'package:magic_tasks/core/constants/app_constants.dart';
import 'package:magic_tasks/core/constants/app_spacing.dart';
import 'package:magic_tasks/core/extensions/build_context_extension.dart';
import 'package:magic_tasks/core/extensions/text_style_extension.dart';
import 'package:magic_tasks/core/routing/route_path.dart';
import 'package:magic_tasks/core/widgets/app_button.dart';
import 'package:magic_tasks/core/widgets/app_loader.dart';
import 'package:magic_tasks/core/widgets/app_scaffold.dart';
import 'package:magic_tasks/core/widgets/app_state.dart';
import 'package:magic_tasks/core/widgets/gap.dart';
import 'package:magic_tasks/features/task/models/enum.dart';
import 'package:magic_tasks/features/task/models/task.dart';
import 'package:magic_tasks/features/task/view/bloc/task_bloc.dart';
import 'package:magic_tasks/features/task/view/widgets/chips_list.dart';
import 'package:magic_tasks/features/task/view/widgets/search_widget.dart';
import 'package:magic_tasks/features/task/view/widgets/task_card.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:intl/intl.dart';

class TasksPage extends StatefulWidget {
  const TasksPage({super.key});

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  int _idx = 0;
  final topics = ['All', 'Pending', 'Completed'];

  @override
  void initState() {
    super.initState();
    context.read<TaskBloc>().add(LoadTasks());
  }

  List<Task> _filterTasks(List<Task> tasks) {
    switch (_idx) {
      case 0:
        return tasks;
      case 1:
        return tasks.where((task) => task.status == Status.pending).toList();
      case 2:
        return tasks.where((task) => task.status == Status.completed).toList();
      default:
        return tasks;
    }
  }

  Map<String, List<Task>> _groupTasksByDate(List<Task> tasks) {
    final Map<String, List<Task>> grouped = {};
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    for (var task in tasks) {
      final taskDate = DateTime(
        task.createdAt.year,
        task.createdAt.month,
        task.createdAt.day,
      );

      String dateKey;
      if (taskDate == today) {
        dateKey = 'Today';
      } else if (taskDate == yesterday) {
        dateKey = 'Yesterday';
      } else if (taskDate.isAfter(today.subtract(const Duration(days: 7)))) {
        dateKey = DateFormat('EEEE').format(taskDate); // Day name
      } else if (taskDate.year == now.year) {
        dateKey = DateFormat('MMMM d').format(taskDate); // Month Day
      } else {
        dateKey = DateFormat('MMM d, yyyy').format(taskDate); // Full date
      }

      if (!grouped.containsKey(dateKey)) {
        grouped[dateKey] = [];
      }
      grouped[dateKey]!.add(task);
    }

    // Sort groups by date (most recent first)
    final sortedEntries = grouped.entries.toList()
      ..sort((a, b) {
        final aDate = a.value.first.createdAt;
        final bDate = b.value.first.createdAt;
        return bDate.compareTo(aDate);
      });

    return Map.fromEntries(sortedEntries);
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.play_circle_outline_outlined),
          ),
        ],
      ),
      drawer: Drawer(backgroundColor: AppColors.surface),
      floatingActionButton: AppButton(
        icon: Icon(
          Symbols.add,
          color: context.isDark ? AppColors.dark : AppColors.light,
        ),
        text: AppConstants.createTask,
        textStyle: context.bodyLarge?.copyWith(
          color: context.isDark ? AppColors.surface : AppColors.light,
          fontWeight: FontWeight.w600,
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: context.isDark ? AppColors.light : AppColors.dark,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32),
          ),
        ),
        onPressed: () => context.go(RoutePath.taskDetails.path),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: AppSpacing.sm,
        children: [
          SearchBarWidget(),
          ChipsList(
            topics: topics,
            initialSelected: topics[_idx],
            onFilterSelected: (f) => setState(() => _idx = topics.indexOf(f)),
          ),
          Expanded(
            child: BlocBuilder<TaskBloc, TaskState>(
              builder: (context, state) {
                if (state is TaskLoading) const AppLoader();
                if (state is TaskError) {
                  return AppState.error(
                    title: state.message,
                    action: () {
                      context.read<TaskBloc>().add(LoadTasks());
                    },
                  );
                }
                if (state is TaskLoaded) {
                  final filteredTasks = _filterTasks(state.tasks);
                  if (filteredTasks.isEmpty) {
                    return AppState.noData(
                      icon: Icons.task_alt,
                      title: AppConstants.noTasksMessage,
                      subtitle: AppConstants.addTaskMessage,
                    );
                  }

                  final groupedTasks = _groupTasksByDate(filteredTasks);

                  return RefreshIndicator(
                    backgroundColor: context.isDark
                        ? AppColors.surface
                        : AppColors.disabled,
                    child: ListView.builder(
                      itemCount: groupedTasks.length,
                      itemBuilder: (context, index) {
                        final dateKey = groupedTasks.keys.elementAt(index);
                        final tasksForDate = groupedTasks[dateKey]!;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.xlg,
                              ),
                              child: Text(
                                dateKey,
                                style: context.titleMedium?.copyWith(
                                  color: AppColors.grey,
                                ),
                              ),
                            ),
                            ...tasksForDate.map((task) {
                              return TaskCard(
                                task: task,
                                onToggle: () {
                                  context.read<TaskBloc>().add(
                                        ToggleTaskCompletion(task.id),
                                      );
                                },
                                onDelete: () {
                                  context
                                      .read<TaskBloc>()
                                      .add(DeleteTask(task.id));
                                },
                              );
                            }),
                            Gap.v(AppSpacing.sm),
                          ],
                        );
                      },
                    ),
                    onRefresh: () async {
                      Future.delayed(Duration(seconds: 3));
                      context.read<TaskBloc>().add(LoadTasks());
                    },
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}