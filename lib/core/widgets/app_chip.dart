import 'package:flutter/material.dart';
import 'package:magic_tasks/core/constants/app_colors.dart';
import 'package:magic_tasks/core/constants/app_spacing.dart';
import 'package:magic_tasks/core/extensions/build_context_extension.dart';
import 'package:magic_tasks/core/extensions/text_style_extension.dart';

class AppChip extends StatelessWidget {
  const AppChip({
    required this.label,
    required this.isSelected,
    required this.onSelected,
    this.icon,
    this.backgroundColor,
    this.padding,
    super.key,
  });

  const AppChip.custom({
    required String label,
    required bool isSelected,
    required Function(bool) onSelected,
    Widget? icon,
    Color? backgroundColor,
    EdgeInsetsGeometry? padding,
    Key? key,
  }) : this(
         label: label,
         isSelected: isSelected,
         onSelected: onSelected,
         icon: icon,
         backgroundColor: backgroundColor,
         padding: padding,
         key: key,
       );

  final String label;
  final bool isSelected;
  final Function(bool) onSelected;
  final Widget? icon;
  final Color? backgroundColor;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final borderRadius = 24.0;
    final isDark = context.isDark;

    final Color textColor;
    final Color iconColor;
    final Color chipBackgroundColor;
    final Color chipSelectedColor;

    if (isDark) {
      textColor = isSelected ? AppColors.dark : AppColors.grey;
      iconColor = isSelected ? AppColors.dark : AppColors.grey;
      chipBackgroundColor = AppColors.dark;
      chipSelectedColor = AppColors.light;
    } else {
      textColor = isSelected ? AppColors.light : AppColors.grey;
      iconColor = isSelected ? AppColors.light : AppColors.grey;
      chipBackgroundColor = AppColors.disabled;
      chipSelectedColor = AppColors.dark;
    }

    return FilterChip(
      label: Text(label),
      labelStyle: context.bodyMedium?.copyWith(
        color: textColor,
        fontWeight: FontWeight.w700,
      ),
      labelPadding: padding ?? EdgeInsets.symmetric(horizontal: AppSpacing.sm),
      avatar: icon != null
          ? IconTheme(
              data: IconThemeData(
                color: iconColor,
                size: 20,
              ),
              child: icon!,
            )
          : null,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      backgroundColor: backgroundColor ?? chipBackgroundColor,
      selectedColor: chipSelectedColor,
      showCheckmark: false,
      selected: isSelected,
      onSelected: onSelected,
    );
  }
}