import 'package:flutter/material.dart';
import 'package:ryser/app/theme/ryser_colors.dart';

abstract final class RyserTheme {
  static ThemeData get dark {
    const scheme = ColorScheme.dark(
      primary: RyserColors.primary,
      onPrimary: RyserColors.background,
      secondary: RyserColors.primaryDim,
      onSecondary: RyserColors.background,
      error: RyserColors.critical,
      onError: RyserColors.background,
      surface: RyserColors.surface,
      onSurface: RyserColors.textPrimary,
      outline: RyserColors.muted,
      onSurfaceVariant: RyserColors.textSecondary,
    );
    final base = ThemeData(
      fontFamily: 'Roboto',
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: scheme,
    );
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(14),
    );
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: RyserColors.muted),
    );
    return base.copyWith(
      scaffoldBackgroundColor: Colors.transparent,
      textTheme: base.textTheme
          .apply(
            bodyColor: RyserColors.textPrimary,
            displayColor: RyserColors.textPrimary,
          )
          .copyWith(
            bodyLarge: const TextStyle(
              fontFamily: 'Roboto',
              fontSize: 16,
              height: 1.45,
              color: RyserColors.textPrimary,
            ),
            bodyMedium: const TextStyle(
              fontFamily: 'Roboto',
              fontSize: 14,
              height: 1.5,
              color: RyserColors.textPrimary,
            ),
            bodySmall: const TextStyle(
              fontFamily: 'Roboto',
              fontSize: 12,
              height: 1.45,
              color: RyserColors.textSecondary,
            ),
          ),
      appBarTheme: const AppBarTheme(
        backgroundColor: RyserColors.background,
        foregroundColor: RyserColors.textPrimary,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontFamily: 'monospace',
          color: RyserColors.textPrimary,
          fontSize: 19,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.5,
        ),
      ),
      dividerColor: RyserColors.inactive,
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: RyserColors.surfaceRaised,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 20,
        ),
        labelStyle: const TextStyle(
          fontSize: 13,
          color: RyserColors.textSecondary,
        ),
        floatingLabelStyle: const TextStyle(color: RyserColors.primary),
        helperMaxLines: 3,
        errorMaxLines: 3,
        enabledBorder: border,
        border: border,
        focusedBorder: border.copyWith(
          borderSide: const BorderSide(color: RyserColors.primary, width: 1.5),
        ),
        errorBorder: border.copyWith(
          borderSide: const BorderSide(color: RyserColors.critical),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(48, 56),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          foregroundColor: RyserColors.background,
          backgroundColor: RyserColors.primary,
          textStyle: const TextStyle(
            fontFamily: 'Roboto',
            fontSize: 14,
            fontWeight: FontWeight.w800,
            letterSpacing: .8,
          ),
          shape: shape,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          textStyle: const TextStyle(
            fontFamily: 'Roboto',
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
          minimumSize: const Size(48, 52),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          side: const BorderSide(color: RyserColors.muted),
          foregroundColor: RyserColors.primary,
          shape: shape,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(minimumSize: const Size(48, 48)),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          minimumSize: const Size(48, 48),
          foregroundColor: RyserColors.primary,
        ),
      ),
      cardTheme: CardThemeData(
        color: RyserColors.surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: shape.copyWith(side: const BorderSide(color: RyserColors.muted)),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.disabled)
              ? RyserColors.textSecondary
              : states.contains(WidgetState.selected)
              ? RyserColors.primary
              : RyserColors.textSecondary,
        ),
        trackColor: WidgetStateProperty.all(RyserColors.surfaceRaised),
        trackOutlineColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? RyserColors.primaryDim
              : RyserColors.muted,
        ),
      ),
      chipTheme: base.chipTheme.copyWith(
        shape: const StadiumBorder(),
        side: const BorderSide(color: RyserColors.muted),
        selectedColor: RyserColors.inactive,
        backgroundColor: RyserColors.surface,
        labelStyle: const TextStyle(
          color: RyserColors.textPrimary,
          fontSize: 12,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: RyserColors.surfaceRaised,
        shape: shape,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: RyserColors.surfaceRaised,
        behavior: SnackBarBehavior.floating,
        contentTextStyle: const TextStyle(
          color: RyserColors.textPrimary,
          fontSize: 14,
        ),
        shape: shape,
      ),
      listTileTheme: const ListTileThemeData(
        iconColor: RyserColors.primary,
        minVerticalPadding: 12,
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: RyserColors.primary,
      ),
    );
  }
}
