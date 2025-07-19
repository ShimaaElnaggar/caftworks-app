import 'package:craftworks_app/core/constants/app_theme.dart';
import 'package:flutter/material.dart';

class AppFonts {
  static const String primaryFont = 'Roboto';

  static const TextStyle heading1 = TextStyle(
    fontFamily: primaryFont,
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.primary,
  );

  static const TextStyle heading2 = TextStyle(
    fontFamily: primaryFont,
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.primary100,
  );

  static const TextStyle bodyText = TextStyle(
    fontFamily: primaryFont,
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.foreground,
  );

  static const TextStyle caption = TextStyle(
    fontFamily: primaryFont,
    fontSize: 12,
    fontWeight: FontWeight.w300,
    color: AppColors.mutedForeground,
  );
}
