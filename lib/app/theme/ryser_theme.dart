import 'package:flutter/material.dart';
import 'package:ryser/app/theme/ryser_colors.dart';

abstract final class RyserTheme {
  static ThemeData get dark {
    const colorScheme = ColorScheme.dark(
      primary: RyserColors.primary,
      onPrimary: RyserColors.background,
      secondary: RyserColors.primaryDim,
      onSecondary: RyserColors.background,
      error: RyserColors.critical,
      onError: RyserColors.background,
      surface: RyserColors.surface,
      onSurface: RyserColors.textPrimary,
      outline: RyserColors.muted,
    );

    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: RyserColors.background,
      fontFamily: 'monospace',
    );

    return base.copyWith(
      textTheme: base.textTheme.apply(
        bodyColor: RyserColors.textPrimary,
        displayColor: RyserColors.textPrimary,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: RyserColors.background,
        foregroundColor: RyserColors.textPrimary,
        elevation: 0,
        centerTitle: false,
      ),
      dividerColor: RyserColors.inactive,
      inputDecorationTheme: const InputDecorationTheme(
        filled: true,
        fillColor: RyserColors.surface,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: RyserColors.muted),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: RyserColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: RyserColors.critical),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(48, 52),
          foregroundColor: RyserColors.background,
          backgroundColor: RyserColors.primary,
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
          ),
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: RyserColors.primary,
        foregroundColor: RyserColors.background,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      ),
      chipTheme: base.chipTheme.copyWith(
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        side: const BorderSide(color: RyserColors.muted),
        selectedColor: RyserColors.primary,
        backgroundColor: RyserColors.surface,
      ),
    );
  }
}
