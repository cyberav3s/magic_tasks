import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:magic_tasks/core/constants/app_colors.dart';
import 'package:magic_tasks/core/constants/app_spacing.dart';
import 'package:magic_tasks/core/extensions/build_context_extension.dart';
import 'package:magic_tasks/core/extensions/text_style_extension.dart';
import 'package:magic_tasks/core/models/modal_option.dart';
import 'package:magic_tasks/core/widgets/app_button.dart';
import 'package:magic_tasks/core/widgets/app_divider.dart';
import 'package:magic_tasks/core/widgets/gap.dart';
import 'package:magic_tasks/core/widgets/tappable.dart';

/// The signature for the callback that uses the [BuildContext].
typedef BuildContextCallback = void Function(BuildContext context);

/// {@template show_dialog_extension}
/// Dialog extension that shows dialog with optional `title`,
/// `content` and `actions`.
/// {@endtemplate}
extension DialogExtension on BuildContext {
  Future<bool?> showConfirmationBottomSheet({
    required String title,
    required String okText,
    Widget? icon,
    String? question,
    String? cancelText,
  }) {
    return showModalBottomSheet(
      context: this,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Gap.v(AppSpacing.xlg),
            if (icon != null) icon,
            const Gap.v(AppSpacing.xlg),
            Text(
              title,
              style: context.headlineLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const Gap.v(AppSpacing.sm),
            if (question != null) Text(question, textAlign: TextAlign.center),
            const Gap.v(AppSpacing.xxlg),
            const AppDivider(),
            Row(
              children: [
                if (cancelText != null)
                  Flexible(
                    child: Container(
                      alignment: Alignment.center,
                      child: TextButton(
                        onPressed: () {
                          pop(false);
                        },
                        child: Text(
                          cancelText,
                          style: context.bodyLarge?.copyWith(
                            color: context.adaptiveColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                Flexible(
                  child: Container(
                    alignment: Alignment.center,
                    child: TextButton(
                      onPressed: () => pop(true),
                      child: Text(
                        okText,
                        style: context.bodyLarge?.copyWith(
                          color: AppColors.error,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Future<T?> showAdaptiveDialog<T>({
    String? content,
    String? title,
    List<Widget> actions = const [],
    bool barrierDismissible = true,
    Widget Function(BuildContext)? builder,
    TextStyle? titleTextStyle,
  }) => showDialog<T>(
    context: this,
    barrierDismissible: barrierDismissible,
    builder:
        builder ??
        (context) {
          return AlertDialog.adaptive(
            actionsAlignment: MainAxisAlignment.end,
            title: Text(title!),
            titleTextStyle: titleTextStyle,
            content: content == null ? null : Text(content),
            actions: actions,
          );
        },
  );

  /// Shows bottom modal.
  Future<T?> showBottomModal<T>({
    Widget Function(BuildContext context)? builder,
    String? title,
    Color? titleColor,
    Widget? content,
    Color? backgroundColor,
    Color? barrierColor,
    ShapeBorder? border,
    bool rounded = true,
    bool isDismissible = true,
    bool isScrollControlled = false,
    bool enableDrag = true,
    bool useSafeArea = true,
    bool showDragHandle = true,
  }) => showModalBottomSheet(
    context: this,
    shape:
        border ??
        (!rounded
            ? null
            : const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              )),
    showDragHandle: showDragHandle,
    backgroundColor: backgroundColor,
    barrierColor: barrierColor,
    clipBehavior: Clip.antiAliasWithSaveLayer,
    isDismissible: isDismissible,
    enableDrag: enableDrag,
    useSafeArea: useSafeArea,
    isScrollControlled: isScrollControlled,
    useRootNavigator: true,
    builder:
        builder ??
        (context) {
          return Material(
            type: MaterialType.transparency,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (title != null) ...[
                  Text(
                    title,
                    style: context.titleLarge?.copyWith(color: titleColor),
                  ),
                  const Divider(),
                ],
                content!,
              ],
            ),
          );
        },
  );

  Future<ModalOption?> showListOptionsModal({
    required List<ModalOption> options,
    String? title,
  }) => showBottomModal<ModalOption>(
    isScrollControlled: true,
    title: title,
    content: SafeArea(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: options
              .map(
                (option) =>
                    option.child ??
                    Tappable.faded(
                      onTap: () {
                        pop(option);
                        option.onTap.call(this);
                      },
                      padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
                      child: ListTile(
                        title: option.name == null
                            ? null
                            : Text(
                                option.name!,
                                style: bodyLarge?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color:
                                      option.nameColor ??
                                      option.distractiveColor,
                                ),
                              ),
                        subtitle: option.content == null
                            ? null
                            : Text(
                                option.content!,
                                style: bodySmall?.copyWith(
                                  color:
                                      option.contentColor ??
                                      option.distractiveColor,
                                ),
                              ),
                        trailing: option.icon == null && option.iconData == null
                            ? null
                            : option.icon ??
                                  Icon(
                                    option.iconData,
                                    color: option.distractiveColor,
                                  ),
                      ),
                    ),
              )
              .toList(),
        ),
      ),
    ),
  );

  /// Shows the confirmation dialog and upon confirmation executes provided
  /// [fn].
  Future<void> confirmAction({
    required void Function() fn,
    required String title,
    required String noText,
    required String yesText,
    String? content,
    TextStyle? yesTextStyle,
    TextStyle? noTextStyle,
    BuildContextCallback? noAction,
  }) async {
    final isConfirmed = await showConfirmationDialog(
      title: title,
      content: content,
      noText: noText,
      yesText: yesText,
      yesTextStyle: yesTextStyle,
      noTextStyle: noTextStyle,
      noAction: noAction,
    );
    if (isConfirmed == null || !isConfirmed) return;
    fn.call();
  }

  /// Shows a dialog that alerts user that they are about to do distractive
  /// action.
  Future<bool?> showConfirmationDialog({
    required String title,
    required String noText,
    required String yesText,
    String? content,
    BuildContextCallback? noAction,
    BuildContextCallback? yesAction,
    TextStyle? noTextStyle,
    TextStyle? yesTextStyle,
    bool distractiveAction = true,
    bool barrierDismissible = true,
  }) => showAdaptiveDialog<bool?>(
    title: title,
    content: content,
    barrierDismissible: barrierDismissible,
    titleTextStyle: headlineSmall,
    actions: [
      AppButton(
        isDialogButton: true,
        isDefaultAction: true,
        onPressed: () => noAction == null
            ? (canPop() ? pop(false) : null)
            : noAction.call(this),
        text: noText,
        textStyle: noTextStyle ?? labelLarge?.apply(color: adaptiveColor),
      ),
      AppButton(
        isDialogButton: true,
        isDestructiveAction: true,
        onPressed: () => yesAction == null
            ? (canPop() ? pop(true) : null)
            : yesAction.call(this),
        text: yesText,
        textStyle: yesTextStyle ?? labelLarge?.apply(color: AppColors.error),
      ),
    ],
  );
}
