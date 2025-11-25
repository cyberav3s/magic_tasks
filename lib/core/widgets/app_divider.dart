import 'package:flutter/material.dart';
import 'package:magic_tasks/core/constants/app_colors.dart';
import 'package:magic_tasks/core/extensions/build_context_extension.dart';

class AppDivider extends StatelessWidget {
  const AppDivider({
    super.key,
    this.height,
    this.indent,
    this.endIndent,
    this.color,
  });

  final double? height;
  final double? indent;
  final double? endIndent;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final effectiveColor = context.customReversedAdaptiveColor(
      dark: AppColors.surface,
      light: AppColors.disabled,
    );

    return Divider(
      height: height,
      indent: indent,
      endIndent: endIndent,
      color: color ?? effectiveColor,
    );
  }
}

class AppSliverDivider extends StatelessWidget {
  const AppSliverDivider({
    super.key,
    this.height,
    this.indent,
    this.endIndent,
    this.color,
  });

  final double? height;
  final double? indent;
  final double? endIndent;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: AppDivider(
        color: color,
        endIndent: endIndent,
        indent: indent,
        height: height,
      ),
    );
  }
}
