import 'package:flutter/material.dart';
import 'package:magic_tasks/core/constants/app_colors.dart';

class AppLoader extends StatelessWidget {
  const AppLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 32,
        width: 32,
        child: CircularProgressIndicator.adaptive(
          backgroundColor: AppColors.surface,
          strokeWidth: 4,
          valueColor: AlwaysStoppedAnimation<Color>(
            AppColors.primary,
          ),
        ),
      ),
    );
  }
}
