import 'package:flutter/material.dart';
import 'package:xnime_app/core/theme/app_colors.dart';
import 'package:xnime_app/core/theme/app_text_theme.dart';

class AppTheme {
  static ThemeData get def {
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'Poppins',
      scaffoldBackgroundColor: AppColors.dark,
      colorScheme: ColorScheme(
        brightness: Brightness.dark,
        primary: AppColors.light,
        onPrimary: AppColors.dark,
        secondary: AppColors.semiDark,
        onSecondary: AppColors.light,
        error: AppColors.error,
        onError: AppColors.light,
        surface: AppColors.surface,
        onSurface: AppColors.light,
      ),
      textTheme: AppTextTheme.textTheme,
    );
  }
}
