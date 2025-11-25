import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:magic_tasks/core/theme/app_theme.dart';
import 'package:magic_tasks/core/extensions/build_context_extension.dart';
import 'package:magic_tasks/core/extensions/text_style_extension.dart';

class AppScaffold extends StatelessWidget {
  const AppScaffold({
    required this.body,
    super.key,
    this.onPopInvokedWithResult,
    this.canPop,
    this.safeArea = true,
    this.top = true,
    this.bottom = true,
    this.left = true,
    this.right = true,
    this.releaseFocus = false,
    this.resizeToAvoidBottomInset = false,
    this.extendBody = false,
    this.backgroundColor,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.appBar,
    this.bottomNavigationBar,
    this.drawer,
    this.bottomSheet,
    this.extendBodyBehindAppBar = false,
  });

  final bool safeArea;
  final bool top;
  final bool bottom;
  final bool right;
  final bool left;
  final bool releaseFocus;
  final bool resizeToAvoidBottomInset;
  final Widget body;
  final Color? backgroundColor;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final Widget? bottomNavigationBar;
  final PreferredSizeWidget? appBar;
  final Widget? drawer;
  final Widget? bottomSheet;
  final void Function(bool, dynamic)? onPopInvokedWithResult;
  final bool? canPop;
  final bool extendBody;
  final bool extendBodyBehindAppBar;

  @override
  Widget build(BuildContext context) {
    if (releaseFocus) {
      return GestureDetector(
        onTap: () => _releaseFocus(context),
        child: _MaterialScaffold(
          top: top,
          bottom: bottom,
          right: right,
          left: left,
          body: body,
          withSafeArea: safeArea,
          backgroundColor: backgroundColor,
          floatingActionButton: floatingActionButton,
          floatingActionButtonLocation: floatingActionButtonLocation,
          bottomNavigationBar: bottomNavigationBar,
          appBar: appBar,
          drawer: drawer,
          bottomSheet: bottomSheet,
          onPopInvokedWithResult: onPopInvokedWithResult,
          canPop: canPop,
          extendBody: extendBody,
          extendBodyBehindAppBar: extendBodyBehindAppBar,
        ),
      );
    }
    return _MaterialScaffold(
      top: top,
      bottom: bottom,
      right: right,
      left: left,
      body: body,
      withSafeArea: safeArea,
      backgroundColor: backgroundColor,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      bottomNavigationBar: bottomNavigationBar,
      appBar: appBar,
      drawer: drawer,
      bottomSheet: bottomSheet,
      onPopInvokedWithResult: onPopInvokedWithResult,
      canPop: canPop,
      extendBody: extendBody,
      extendBodyBehindAppBar: extendBodyBehindAppBar,
    );
  }

  void _releaseFocus(BuildContext context) => FocusScope.of(context).unfocus();
}

class _MaterialScaffold extends StatelessWidget {
  const _MaterialScaffold({
    required this.top,
    required this.bottom,
    required this.right,
    required this.left,
    required this.body,
    required this.withSafeArea,
    required this.extendBody,
    required this.extendBodyBehindAppBar,
    this.canPop,
    this.backgroundColor,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.bottomNavigationBar,
    this.appBar,
    this.drawer,
    this.bottomSheet,
    this.onPopInvokedWithResult,
  });

  final bool top;
  final bool bottom;
  final bool right;
  final bool left;
  final Widget body;
  final bool withSafeArea;
  final Color? backgroundColor;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final Widget? bottomNavigationBar;
  final PreferredSizeWidget? appBar;
  final Widget? drawer;
  final Widget? bottomSheet;
  final void Function(bool, dynamic)? onPopInvokedWithResult;
  final bool? canPop;
  final bool extendBody;
  final bool extendBodyBehindAppBar;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          extendBody: extendBody,
          extendBodyBehindAppBar: extendBodyBehindAppBar,
          body: withSafeArea
              ? SafeArea(
                  top: top,
                  bottom: bottom,
                  right: right,
                  left: left,
                  child: body,
                )
              : body,
          backgroundColor: backgroundColor,
          floatingActionButton: floatingActionButton,
          floatingActionButtonLocation: floatingActionButtonLocation,
          bottomNavigationBar: bottomNavigationBar,
          appBar: appBar,
          drawer: drawer,
          bottomSheet: bottomSheet,
        )
        .withPopScope(onPopInvokedWithResult, canPop: canPop)
        .withAdaptiveSystemTheme(context);
  }
}

extension PopScopeX on Widget {
  Widget withPopScope(
    void Function(bool, dynamic)? onPopInvokedWithResult, {
    bool? canPop,
  }) => onPopInvokedWithResult == null && canPop == null
      ? this
      : PopScope(
          onPopInvokedWithResult: onPopInvokedWithResult,
          canPop: canPop ?? true,
          child: this,
        );
}

extension SystemNavigationBarTheme on Widget {
  Widget withAdaptiveSystemTheme(BuildContext context) =>
      AnnotatedRegion<SystemUiOverlayStyle>(
        value: context.theme.platform == TargetPlatform.android
            ? context.isLight
                  ? SystemUiOverlayTheme.androidLightSystemBarTheme
                  : SystemUiOverlayTheme.androidDarkSystemBarTheme
            : context.isLight
            ? SystemUiOverlayTheme.iOSDarkSystemBarTheme
            : SystemUiOverlayTheme.iOSLightSystemBarTheme,
        child: this,
      );
}
