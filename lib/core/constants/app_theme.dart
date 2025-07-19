import 'package:flutter/material.dart';

class AppColors {
  // dark
  static const background = Color(0xFF1D1D1D);
  static const foreground = Color(0xFFFBFBFB);
  static const muted = Color(0xFF464646);
  static const mutedForeground = Color(0xFFB3B3B3);
  static const popover = Color(0xFF464646);
  static const popoverForeground = Color(0xFFFBFBFB);
  static const card = Color(0xFF464646);
  static const cardForeground = Color(0xFFFBFBFB);
  static const border = Color(0xFF3C3C3C);
  static const input = Color(0xFF212121);
  static const primary = Color(0xFF939DFF);
  static const primaryForeground = Color(0xFF1D1D1D);
  static const primary100 = Color(0xFF33367D);
  static const primary200 = Color(0xFF3C43A9);
  static const primary300 = Color(0xFF4550D4);
  static const primary400 = Color(0xFF5865F2);
  static const primary500 = Color(0xFF939DFF);
  static const primary600 = Color(0xFFB1BAFF);
  static const primary700 = Color(0xFFCAD0FF);
  static const primary800 = Color(0xFFE0E3FF);
  static const primary900 = Color(0xFFEFF0FF);
  static const secondary = Color(0xFF3C3C3C);
  static const secondaryForeground = Color(0xFFFBFBFB);
  static const accent = Color(0xFF4E4F63);
  static const accentForeground = Color(0xFFFBFBFB);
  static const destructive = Color(0xFFDD5247);
  static const destructiveForeground = Color(0xFFFBFBFB);
  static const success = Color(0xFF5ED095);
  static const successForeground = Color(0xFF1D1D1D);
  static const warning = Color(0xFFC7DB56);
  static const warningForeground = Color(0xFF1D1D1D);
  static const info = Color(0xFF939DFF);
  static const infoForeground = Color(0xFF1D1D1D);
  static const ring = Color(0xFF939DFF);

  // LIGHT
  static final glowBlue = BoxShadow(
    color: Colors.blue.withOpacity(0.3),
    blurRadius: 100,
    spreadRadius: 100,
  );
  static const backgroundLight = Color(0xFFFBFBFB);
  static const foregroundLight = Color(0xFF464646);
  static const mutedLight = Color(0xFFF7F7F7);
  static const mutedForegroundLight = Color(0xFF989898);
  static const popoverLight = Color(0xFFFFFFFF);
  static const popoverForegroundLight = Color(0xFF464646);
  static const cardLight = Color(0xFFFFFFFF);
  static const cardForegroundLight = Color(0xFF464646);
  static const borderLight = Color(0xFFEFEFEF);
  static const inputLight = Color(0xFFFDFDFD);
  static const primaryLight = Color(0xFF5865F2);
  static const primaryForegroundLight = Color(0xFFFFFFFF);
  static const primary100Light = Color(0xFFEFF0FF);
  static const primary200Light = Color(0xFFE0E3FF);
  static const primary300Light = Color(0xFFCAD0FF);
  static const primary400Light = Color(0xFFB1BAFF);
  static const primary500Light = Color(0xFF939DFF);
  static const primary600Light = Color(0xFF5865F2);
  static const primary700Light = Color(0xFF4550D4);
  static const primary800Light = Color(0xFF3C43A9);
  static const primary900Light = Color(0xFF33367D);
  static const secondaryLight = Color(0xFFF5F5FB);
  static const secondaryForegroundLight = Color(0xFF464646);
  static const accentLight = Color(0xFFE9F0FC);
  static const accentForegroundLight = Color(0xFF464646);
  static const destructiveLight = Color(0xFFDD5247);
  static const destructiveForegroundLight = Color(0xFFFFFFFF);
  static const successLight = Color(0xFF5ED095);
  static const successForegroundLight = Color(0xFFFFFFFF);
  static const warningLight = Color(0xFFC7DB56);
  static const warningForegroundLight = Color(0xFF464646);
  static const infoLight = Color(0xFF5865F2);
  static const infoForegroundLight = Color(0xFFFFFFFF);
  static const ringLight = Color(0xFF5865F2);
}

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  scaffoldBackgroundColor: AppColors.backgroundLight,
  cardColor: AppColors.cardLight,
  primaryColor: AppColors.primaryLight,
  colorScheme: ColorScheme.light(
    primary: AppColors.primaryLight,
    secondary: AppColors.secondaryLight,
    background: AppColors.backgroundLight,
    surface: AppColors.cardLight,
    error: AppColors.destructiveLight,
    onPrimary: AppColors.primaryForegroundLight,
    onSecondary: AppColors.secondaryForegroundLight,
    onBackground: AppColors.foregroundLight,
    onSurface: AppColors.cardForegroundLight,
    onError: AppColors.destructiveForegroundLight,
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: AppColors.foregroundLight),
    bodyMedium: TextStyle(color: AppColors.foregroundLight),
    bodySmall: TextStyle(color: AppColors.mutedForegroundLight),
  ),
);

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: AppColors.background,
  cardColor: AppColors.card,
  primaryColor: AppColors.primary,
  colorScheme: ColorScheme.dark(
    primary: AppColors.primary,
    secondary: AppColors.secondary,
    background: AppColors.background,
    surface: AppColors.card,
    error: AppColors.destructive,
    onPrimary: AppColors.primaryForeground,
    onSecondary: AppColors.secondaryForeground,
    onBackground: AppColors.foreground,
    onSurface: AppColors.cardForeground,
    onError: AppColors.destructiveForeground,
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: AppColors.foreground),
    bodyMedium: TextStyle(color: AppColors.foreground),
    bodySmall: TextStyle(color: AppColors.mutedForeground),
  ),
);
