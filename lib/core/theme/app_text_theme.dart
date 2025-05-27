import 'package:flutter/material.dart';
import 'package:xnime_app/core/theme/app_text_styles.dart';

class AppTextTheme {
  static const TextTheme textTheme = TextTheme(
    // Regular
    displayLarge: AppTextStyles.xxxl,
    displayMedium: AppTextStyles.xxl,
    displaySmall: AppTextStyles.xl,
    headlineLarge: AppTextStyles.lg,
    headlineMedium: AppTextStyles.normal,
    headlineSmall: AppTextStyles.sm,
    titleLarge: AppTextStyles.xs,

    // SemiBold
    titleMedium: AppTextStyles.normalSemiBold,
    titleSmall: AppTextStyles.smSemiBold,

    // Bold
    bodyLarge: AppTextStyles.normalBold,
    bodyMedium: AppTextStyles.smBold,
    bodySmall: AppTextStyles.xsBold,

    // Tambahan (opsional)
    labelLarge: AppTextStyles.xlSemiBold,
    labelMedium: AppTextStyles.lgSemiBold,
    labelSmall: AppTextStyles.xs,
  );
}
