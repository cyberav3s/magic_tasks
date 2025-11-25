import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:magic_tasks/core/constants/app_colors.dart';
import 'package:magic_tasks/core/constants/app_spacing.dart';
import 'package:magic_tasks/core/extensions/build_context_extension.dart';
import 'package:magic_tasks/core/extensions/date_extensions.dart';
import 'package:magic_tasks/core/extensions/show_dialog.dart';
import 'package:magic_tasks/core/extensions/text_style_extension.dart';
import 'package:magic_tasks/core/models/modal_option.dart';
import 'package:magic_tasks/core/widgets/app_scaffold.dart';
import 'package:magic_tasks/core/widgets/gap.dart';
import 'package:magic_tasks/core/widgets/tappable.dart';
import 'package:magic_tasks/features/task/models/enum.dart';
import 'package:magic_tasks/features/task/models/task.dart';
import 'package:magic_tasks/features/task/view/bloc/task_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';

class DetailsPage extends StatefulWidget {
  final Task? task;

  const DetailsPage({super.key, this.task});

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late FocusNode _titleFocusNode;
  late FocusNode _descriptionFocusNode;

  late bool isCompleted;
  late String dueDate;
  late Tag tag;
  bool _hasChanges = false;

  bool get _isNewTask => widget.task == null;
  bool get _canSave => _titleController.text.isNotEmpty;

  @override
  void initState() {
    super.initState();
    _initializeFields();
    _setupControllers();
    _requestFocusIfNeeded();
  }

  void _initializeFields() {
    isCompleted = widget.task?.isCompleted ?? false;
    dueDate =
        widget.task?.dueDate.toFormattedDate() ??
        DateTime.now().toFormattedDate();
    tag = widget.task?.tag ?? Tag.habit;
  }

  void _setupControllers() {
    _titleController = TextEditingController(text: widget.task?.title ?? '');
    _descriptionController = TextEditingController(
      text: widget.task?.description ?? '',
    );
    _titleFocusNode = FocusNode();
    _descriptionFocusNode = FocusNode();

    _titleController.addListener(_onTextChanged);
    _descriptionController.addListener(_onTextChanged);
  }

  void _requestFocusIfNeeded() {
    if (_isNewTask) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _titleFocusNode.requestFocus();
      });
    }
  }

  void _onTextChanged() {
    if (!_hasChanges) {
      setState(() => _hasChanges = true);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _titleFocusNode.dispose();
    _descriptionFocusNode.dispose();
    super.dispose();
  }

  void _saveTask() {
    if (!_canSave) return;

    final taskBloc = context.read<TaskBloc>();

    if (_isNewTask) {
      taskBloc.add(
        AddTask(
          DateTime.now(),
          tag,
          isCompleted,
          title: _titleController.text,
          description: _descriptionController.text,
        ),
      );
    } else {
      taskBloc.add(
        UpdateTask(
          widget.task!.copyWith(
            title: _titleController.text,
            description: _descriptionController.text,
            createdAt: DateTime.now(),
            tag: tag,
          ),
        ),
      );
    }

    Navigator.pop(context);
  }

  void _handleBackPress() {
    if (_hasChanges && _canSave) {
      _saveTask();
    } else {
      Navigator.pop(context);
    }
  }

  Future<void> _selectDueDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2026),
    );

    if (picked != null) {
      setState(() {
        dueDate = picked.toFormattedDate();
        _hasChanges = true;
      });
    }
  }

  void _selectTag() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: context.isDark ? AppColors.surface : AppColors.disabled,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _TagSelectionSheet(
        selectedTag: tag,
        onTagSelected: (selectedTag) {
          setState(() {
            tag = selectedTag;
            _hasChanges = true;
          });
          Navigator.pop(context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      backgroundColor: context.isDark ? AppColors.dark : AppColors.light,
      appBar: AppBar(
        leading: IconButton(
          onPressed: _handleBackPress,
          icon: Icon(Symbols.arrow_back),
        ),
        actionsPadding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        actions: [
          Tappable.faded(
            onTap: () {
              context.showListOptionsModal(
                options: [
                  ModalOption(
                    icon: Icon(Symbols.delete_forever),
                    name: 'Delete Task',
                    onTap: () {
                      context.read<TaskBloc>().add(
                        DeleteTask(widget.task!.id.toString()),
                      );
                    },
                  ),
                ],
              );
            },
            borderRadius: BorderRadius.circular(8),
            child: const Padding(
              padding: EdgeInsets.all(AppSpacing.sm),
              child: Icon(Icons.more_horiz),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: context.isDark ? AppColors.light : AppColors.dark,
        onPressed: _saveTask,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
        child: Icon(
          Symbols.done,
          color: context.isDark ? AppColors.dark : AppColors.light,
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.xlg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTitleField(),
                  const Gap.v(AppSpacing.xlg),
                  _buildDetailSection(),
                  const Gap.v(AppSpacing.xlg),
                  _buildDescriptionSection(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitleField() {
    return TextField(
      controller: _titleController,
      focusNode: _titleFocusNode,
      style: context.headlineLarge?.copyWith(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        color: context.isDark ? AppColors.light : AppColors.surface,
        decoration: isCompleted
            ? TextDecoration.lineThrough
            : TextDecoration.none,
        decorationColor: AppColors.textDisabled,
      ),
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: 'Untitled',
        hintStyle: context.headlineLarge?.copyWith(
          color: AppColors.disabled.withAlpha(180),
        ),
        contentPadding: EdgeInsets.zero,
        isDense: true,
      ),
      maxLines: null,
      textCapitalization: TextCapitalization.sentences,
    );
  }

  Widget _buildDetailSection() {
    return Row(
      spacing: AppSpacing.md,
      children: [
        Tappable.faded(
          onTap: _selectDueDate,
          borderRadius: BorderRadius.circular(12),
          child: Row(
            spacing: AppSpacing.sm,
            children: [
              Icon(
                Icons.calendar_today_outlined,
                size: 16,
                color: AppColors.grey,
              ),
              Text(dueDate, style: context.bodyMedium),
            ],
          ),
        ),
        Tappable.faded(
          onTap: _selectTag,
          borderRadius: BorderRadius.circular(12),
          child: Row(
            spacing: AppSpacing.sm,
            children: [
              Icon(Icons.local_offer_outlined, size: 16, color: AppColors.grey),
              Text(tag.name, style: context.bodyMedium),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDescriptionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _descriptionController,
          focusNode: _descriptionFocusNode,
          style: context.bodyLarge?.copyWith(
            color: context.isDark ? AppColors.light : AppColors.surface,
          ),
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: 'Add a description...',
            hintStyle: context.bodyLarge?.copyWith(
              color: AppColors.textDisabled,
            ),
            contentPadding: EdgeInsets.zero,
            isDense: true,
          ),
          maxLines: null,
          textCapitalization: TextCapitalization.sentences,
        ),
      ],
    );
  }
}

class _TagSelectionSheet extends StatelessWidget {
  final Tag selectedTag;
  final ValueChanged<Tag> onTagSelected;

  const _TagSelectionSheet({
    required this.selectedTag,
    required this.onTagSelected,
  });

  @override
  Widget build(BuildContext context) {
    final tagMap = {
      'Habits': Tag.habit,
      'Work': Tag.work,
      'Personal': Tag.personal,
      'Health': Tag.health,
      'Study': Tag.study,
    };

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ...tagMap.entries.map(
            (entry) => Tappable.faded(
              onTap: () => onTagSelected(entry.value),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm,
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.local_offer,
                      color: selectedTag == entry.value
                          ? AppColors.grey
                          : AppColors.textDisabled,
                    ),
                    const Gap.h(AppSpacing.lg),
                    Expanded(child: Text(entry.key, style: context.bodyLarge)),
                    if (selectedTag == entry.value)
                      const Icon(Icons.check, color: AppColors.text),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
