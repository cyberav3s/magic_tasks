// ignore_for_file: inference_failure_on_function_return_type
import 'package:flutter/material.dart';
import 'package:magic_tasks/core/constants/app_colors.dart';
import 'package:magic_tasks/core/constants/app_spacing.dart';
import 'package:magic_tasks/core/extensions/text_style_extension.dart';
import 'package:magic_tasks/core/widgets/app_button.dart';
import 'package:material_symbols_icons/symbols.dart';

class AppState extends StatelessWidget {
  const AppState({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.action,
    this.iconSize = 32,
    this.iconColor,
    super.key,
  });

  const AppState.noData({
    String title = 'No Data',
    String subtitle = 'There is no data to display',
    IconData icon = Symbols.inbox,
    Function()? action,
    double iconSize = 32,
    Color? iconColor,
    Key? key,
  }) : this(
         icon: icon,
         title: title,
         subtitle: subtitle,
         action: action,
         iconSize: iconSize,
         iconColor: iconColor,
         key: key,
       );

  const AppState.noResults({
    String title = 'No Search Results',
    String subtitle = 'Try adjusting your search or filters',
    IconData icon = Symbols.search_check,
    Function()? action,
    double iconSize = 32,
    Color? iconColor,
    Key? key,
  }) : this(
         icon: icon,
         title: title,
         subtitle: subtitle,
         action: action,
         iconSize: iconSize,
         iconColor: iconColor,
         key: key,
       );

  const AppState.noConnection({
    String title = 'No Connection',
    String subtitle = 'Please check your internet connection',
    IconData icon = Symbols.wifi_off,
    Function()? action,
    double iconSize = 32,
    Color? iconColor,
    Key? key,
  }) : this(
         icon: icon,
         title: title,
         subtitle: subtitle,
         action: action,
         iconSize: iconSize,
         iconColor: iconColor,
         key: key,
       );

  const AppState.error({
    String title = 'Something Went Wrong',
    String subtitle = 'An error occurred. Please try again',
    IconData icon = Symbols.error_outline,
    Function()? action,
    double iconSize = 32,
    Color? iconColor,
    Key? key,
  }) : this(
         icon: icon,
         title: title,
         subtitle: subtitle,
         action: action,
         iconSize: iconSize,
         iconColor: iconColor,
         key: key,
       );

  const AppState.custom({
    required IconData icon,
    required String title,
    required String subtitle,
    Function()? action,
    double iconSize = 32,
    Color? iconColor,
    Key? key,
  }) : this(
         icon: icon,
         title: title,
         subtitle: subtitle,
         action: action,
         iconSize: iconSize,
         iconColor: iconColor,
         key: key,
       );

  final IconData icon;
  final String title;
  final String subtitle;
  final Function()? action;
  final double iconSize;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: AppSpacing.lg,
        children: [
          Icon(
            icon,
            size: iconSize,
            color: iconColor ?? AppColors.textDisabled,
          ),
          Column(
            spacing: AppSpacing.sm,
            children: [
              Text(
                title,
                textAlign: TextAlign.center,
                style: context.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: context.bodySmall?.copyWith(
                  color: AppColors.textDisabled,
                ),
              ),
            ],
          ),
          if (action != null)
            AppButton(
              icon: const Icon(Icons.play_arrow_rounded),
              fontWeight: FontWeight.w600,
              fontSize: 14,
              text: 'Retry',
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              onPressed: action,
            ),
        ],
      ),
    );
  }
}
