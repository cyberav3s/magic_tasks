import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:magic_tasks/core/extensions/text_style_extension.dart';

class AppButton extends StatelessWidget {
  const AppButton({
    this.text,
    this.child,
    this.isDialogButton = false,
    this.isDefaultAction = false,
    this.isDestructiveAction = false,
    super.key,
    this.onPressed,
    this.color,
    this.fontSize,
    this.fontWeight,
    this.style,
    this.height,
    this.width,
    this.icon,
    this.loading = false,
    this.iconScale = 1.0,
    this.maxLines,
    this.outlined = false,
    this.textStyle,
  });

  const AppButton.auth(
    String text,
    VoidCallback? onPressed, {
    bool outlined = false,
    Key? key,
    ButtonStyle? style,
  }) : this(
          style: style,
          outlined: outlined,
          text: text,
          onPressed: onPressed,
          key: key,
        );

  const AppButton.outlined({
    required String text,
    VoidCallback? onPressed,
    TextStyle? textStyle,
    Key? key,
    ButtonStyle? style,
  }) : this(
          outlined: true,
          style: style,
          text: text,
          onPressed: onPressed,
          textStyle: textStyle,
          key: key,
        );

  const AppButton.inProgress({
    double scale = 0.6,
    Key? key,
    ButtonStyle? style,
  }) : this(
          text: '',
          style: style,
          iconScale: scale,
          loading: true,
          icon: const CircularProgressIndicator(),
          key: key,
        );

  final void Function()? onPressed;
  final String? text;
  final Widget? child;
  final double? width;
  final double? height;
  final Color? color;
  final double? fontSize;
  final FontWeight? fontWeight;
  final ButtonStyle? style;
  final TextStyle? textStyle;
  final int? maxLines;
  final Widget? icon;
  final double? iconScale;
  final bool loading;
  final bool outlined;
  final bool isDialogButton;
  final bool isDefaultAction;
  final bool isDestructiveAction;

  @override
  Widget build(BuildContext context) {
    final text = _Text(
      text: this.text!,
      style: textStyle,
      maxLines: maxLines,
    );
    final effectiveIcon = icon == null
        ? null
        : Transform.scale(
            scale: iconScale,
            child: icon,
          );
    final effectiveChild = child ?? text;

    final platform = context.theme.platform;
    final isIOS = platform == TargetPlatform.iOS;

    return Builder(
      builder: (_) {
        if (isDialogButton) {
          if (isIOS) {
            return CupertinoDialogAction(
              onPressed: onPressed,
              isDefaultAction: isDefaultAction,
              isDestructiveAction: isDestructiveAction,
              child: effectiveChild,
            );
          } else {
            return TextButton(
              onPressed: onPressed,
              child: effectiveChild,
            );
          }
        }
        if (effectiveIcon != null) {
          return ElevatedButton.icon(
            onPressed: onPressed,
            icon: effectiveIcon,
            style: style,
            label: effectiveChild,
          );
        }
        if (outlined) {
          return OutlinedButton(
            style: style,
            onPressed: onPressed,
            child: effectiveChild,
          );
        }
        if (outlined && effectiveIcon != null) {
          return OutlinedButton.icon(
            style: style,
            onPressed: onPressed,
            icon: effectiveIcon,
            label: effectiveChild,
          );
        }
        return ElevatedButton(
          style: style,
          onPressed: onPressed,
          child: effectiveChild,
        );
      },
    );
  }
}

class _Text extends StatelessWidget {
  const _Text({required this.text, this.style, this.maxLines});

  final String text;
  final TextStyle? style;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle.merge(
      style: style,
      overflow: TextOverflow.ellipsis,
      child: Text(text, maxLines: maxLines),
    );
  }
}
