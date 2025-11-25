import 'package:flutter/material.dart';
import 'package:magic_tasks/core/constants/app_colors.dart';
import 'package:magic_tasks/core/constants/app_spacing.dart';
import 'package:magic_tasks/core/extensions/build_context_extension.dart';
import 'package:magic_tasks/core/extensions/text_style_extension.dart';
import 'package:material_symbols_icons/symbols.dart';

class SearchBarWidget extends StatelessWidget {
  const SearchBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: context.isDark ? AppColors.surface : AppColors.disabled,
          borderRadius: BorderRadius.circular(12),
        ),
        child: TextField(
          decoration: InputDecoration(
            hintText: 'Search',
            hintStyle: context.titleMedium?.copyWith(
              color: context.isDark ? AppColors.textDisabled : AppColors.textDisabled,
            ),
            prefixIcon: Icon(
              Symbols.search,
              color: context.isDark ? AppColors.disabled : AppColors.textDisabled,
            ),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.md,
            ),
          ),
          style: context.titleMedium?.copyWith(
            color: context.isDark ? AppColors.light : AppColors.dark,
          ),
        ),
      ),
    );
  }
}
