import 'dart:async';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:magic_tasks/core/constants/app_colors.dart';
import 'package:magic_tasks/core/constants/app_spacing.dart';
import 'package:magic_tasks/core/theme/text_theme.dart';

class AppTheme {
  const AppTheme();

  Brightness get brightness => Brightness.light;

  Color get backgroundColor => AppColors.light;

  Color get primary => AppColors.dark;

  ThemeData get theme =>
      FlexThemeData.light(
        scheme: FlexScheme.custom,
        colors: FlexSchemeColor.from(
          brightness: brightness,
          primary: primary,
          swapOnMaterial3: true,
        ),
        useMaterial3: true,
        useMaterial3ErrorColors: true,
      ).copyWith(
        textTheme: const AppTheme().textTheme,
        iconTheme: const IconThemeData(color: AppColors.dark),
        inputDecorationTheme: const InputDecorationTheme(
          contentPadding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
          border: OutlineInputBorder(borderSide: BorderSide.none),
        ),
        appBarTheme: const AppBarTheme(
          elevation: 0,
          surfaceTintColor: AppColors.light,
          backgroundColor: AppColors.light,
        ),
        navigationBarTheme: NavigationBarThemeData(
          labelTextStyle: WidgetStateProperty.resolveWith<TextStyle>(
            (Set<WidgetState> states) => states.contains(WidgetState.selected)
                ? const TextStyle(color: AppColors.primary, fontSize: 11)
                : const TextStyle(color: AppColors.textDisabled, fontSize: 11),
          ),
        ),
        bottomSheetTheme: const BottomSheetThemeData(
          showDragHandle: true,
          surfaceTintColor: AppColors.light,
          backgroundColor: AppColors.light,
        ),
      );

  static const SystemUiOverlayStyle iOSDarkSystemBarTheme =
      SystemUiOverlayStyle(
        statusBarBrightness: Brightness.light,
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarIconBrightness: Brightness.light,
      );

  TextTheme get textTheme => contentTextTheme;

  static final TextTheme contentTextTheme =
      TextTheme(
        displayLarge: ContentTextStyle.headline1,
        displayMedium: ContentTextStyle.headline2,
        displaySmall: ContentTextStyle.headline3,
        headlineLarge: ContentTextStyle.headline4,
        headlineMedium: ContentTextStyle.headline5,
        headlineSmall: ContentTextStyle.headline6,
        titleLarge: ContentTextStyle.headline7,
        titleMedium: ContentTextStyle.subtitle1,
        titleSmall: ContentTextStyle.subtitle2,
        bodyLarge: ContentTextStyle.bodyText1,
        bodyMedium: ContentTextStyle.bodyText2,
        labelLarge: ContentTextStyle.button,
        bodySmall: ContentTextStyle.caption,
        labelSmall: ContentTextStyle.overline,
      ).apply(
        bodyColor: AppColors.dark,
        displayColor: AppColors.dark,
        decorationColor: AppColors.dark,
      );

  static final TextTheme uiTextTheme =
      TextTheme(
        displayLarge: UITextStyle.headline1,
        displayMedium: UITextStyle.headline2,
        displaySmall: UITextStyle.headline3,
        headlineMedium: UITextStyle.headline4,
        headlineSmall: UITextStyle.headline5,
        titleLarge: UITextStyle.headline6,
        titleMedium: UITextStyle.subtitle1,
        titleSmall: UITextStyle.subtitle2,
        bodyLarge: UITextStyle.bodyText1,
        bodyMedium: UITextStyle.bodyText2,
        labelLarge: UITextStyle.button,
        bodySmall: UITextStyle.caption,
        labelSmall: UITextStyle.overline,
      ).apply(
        bodyColor: AppColors.dark,
        displayColor: AppColors.dark,
        decorationColor: AppColors.dark,
      );
}

class AppDarkTheme extends AppTheme {
  const AppDarkTheme();

  @override
  Brightness get brightness => Brightness.dark;

  @override
  Color get backgroundColor => AppColors.dark;

  @override
  Color get primary => AppColors.light;

  @override
  TextTheme get textTheme {
    return AppTheme.contentTextTheme.apply(
      bodyColor: AppColors.light,
      displayColor: AppColors.light,
      decorationColor: AppColors.light,
    );
  }

  @override
  ThemeData get theme =>
      FlexThemeData.dark(
        scheme: FlexScheme.custom,
        darkIsTrueBlack: true,
        colors: FlexSchemeColor.from(
          brightness: brightness,
          primary: primary,
          appBarColor: AppColors.dark,
          swapOnMaterial3: true,
        ),
        useMaterial3: true,
        useMaterial3ErrorColors: true,
      ).copyWith(
        scaffoldBackgroundColor: AppColors.dark,
        textTheme: const AppDarkTheme().textTheme,
        iconTheme: const IconThemeData(color: AppColors.light),
        inputDecorationTheme: const InputDecorationTheme(
          contentPadding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
          border: OutlineInputBorder(borderSide: BorderSide.none),
        ),
        appBarTheme: const AppBarTheme(
          elevation: 0,
          backgroundColor: AppColors.dark,
          surfaceTintColor: AppColors.dark,
        ),
        navigationBarTheme: NavigationBarThemeData(
          labelTextStyle: WidgetStateProperty.resolveWith<TextStyle>(
            (Set<WidgetState> states) => states.contains(WidgetState.selected)
                ? const TextStyle(color: AppColors.light, fontSize: 11)
                : const TextStyle(color: AppColors.textDisabled, fontSize: 11),
          ),
        ),
        bottomSheetTheme: const BottomSheetThemeData(
          surfaceTintColor: AppColors.dark,
          backgroundColor: AppColors.dark,
          modalBackgroundColor: AppColors.dark,
        ),
      );
}

class SystemUiOverlayTheme {
  const SystemUiOverlayTheme();

  static const SystemUiOverlayStyle iOSLightSystemBarTheme =
      SystemUiOverlayStyle(
        statusBarBrightness: Brightness.dark,
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarIconBrightness: Brightness.dark,
      );

  static const SystemUiOverlayStyle iOSDarkSystemBarTheme =
      SystemUiOverlayStyle(
        statusBarBrightness: Brightness.light,
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarIconBrightness: Brightness.light,
      );

  static const SystemUiOverlayStyle androidLightSystemBarTheme =
      SystemUiOverlayStyle(
        statusBarBrightness: Brightness.light,
        statusBarColor: AppColors.light,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarIconBrightness: Brightness.dark,
      );

  static const SystemUiOverlayStyle androidDarkSystemBarTheme =
      SystemUiOverlayStyle(
        statusBarBrightness: Brightness.dark,
        statusBarColor: AppColors.dark,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarIconBrightness: Brightness.light,
      );

  static void setPortraitOrientation() {
    unawaited(SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]));
  }
}
