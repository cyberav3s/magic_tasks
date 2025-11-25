// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:magic_tasks/core/constants/app_colors.dart';
import 'package:magic_tasks/core/constants/app_spacing.dart';
import 'package:magic_tasks/core/extensions/build_context_extension.dart';
import 'package:magic_tasks/core/extensions/date_extensions.dart';
import 'package:magic_tasks/core/extensions/text_style_extension.dart';
import 'package:magic_tasks/core/widgets/gap.dart';
import 'package:magic_tasks/core/widgets/tappable.dart';
import 'package:magic_tasks/features/task/models/task.dart';
import 'package:magic_tasks/features/task/view/pages/details_page.dart';
import 'package:material_symbols_icons/symbols.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback? onToggle;
  final VoidCallback? onDelete;

  const TaskCard({super.key, required this.task, this.onToggle, this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Tappable.faded(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DetailsPage(task: task)),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.xs,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Checkbox.adaptive(
              value: task.isCompleted,
              onChanged: (value) => onToggle,
              checkColor: task.isCompleted ? AppColors.success : AppColors.grey,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(width: AppSpacing.lg),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: AppSpacing.sm,
              children: [
                Text(
                  task.title,
                  style: context.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    decoration: task.isCompleted
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                    decorationColor: Colors.grey,
                    color: context.isDark ? AppColors.light : AppColors.surface,
                  ),
                ),
                Text(
                  task.description,
                  style: context.bodyLarge?.copyWith(
                    color: context.isDark ? AppColors.textDisabled : AppColors.surface,
                    height: 1.4,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                Wrap(
                  spacing: AppSpacing.md,
                  runSpacing: AppSpacing.xs,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Symbols.calendar_today,
                          size: 16,
                          color: Colors.grey[500],
                        ),
                        const Gap.h(AppSpacing.sm),
                        Text(
                          task.createdAt.toFormattedDate(),
                          style: context.labelMedium?.copyWith(
                            color: AppColors.grey,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Symbols.tag, size: 16, color: Colors.grey[500]),
                        const Gap.h(AppSpacing.sm),
                        Text(
                          task.tag.name,
                          style: context.labelMedium?.copyWith(
                            color: AppColors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
