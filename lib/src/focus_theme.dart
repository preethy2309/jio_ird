import 'package:flutter/material.dart';

@immutable
class FocusTheme extends ThemeExtension<FocusTheme> {
  final Color focusedColor;
  final Color unfocusedColor;
  final Color focusedTextColor;
  final Color unfocusedTextColor;

  const FocusTheme({
    required this.focusedColor,
    required this.unfocusedColor,
    required this.focusedTextColor,
    required this.unfocusedTextColor,
  });

  @override
  FocusTheme copyWith({
    Color? focusedColor,
    Color? unfocusedColor,
    Color? focusedTextColor,
    Color? unfocusedTextColor,
  }) {
    return FocusTheme(
      focusedColor: focusedColor ?? this.focusedColor,
      unfocusedColor: unfocusedColor ?? this.unfocusedColor,
      focusedTextColor: focusedTextColor ?? this.focusedTextColor,
      unfocusedTextColor: unfocusedTextColor ?? this.unfocusedTextColor,
    );
  }

  @override
  FocusTheme lerp(ThemeExtension<FocusTheme>? other, double t) {
    if (other is! FocusTheme) return this;
    return FocusTheme(
      focusedColor: Color.lerp(focusedColor, other.focusedColor, t)!,
      unfocusedColor: Color.lerp(unfocusedColor, other.unfocusedColor, t)!,
      focusedTextColor:
      Color.lerp(focusedTextColor, other.focusedTextColor, t)!,
      unfocusedTextColor:
      Color.lerp(unfocusedTextColor, other.unfocusedTextColor, t)!,
    );
  }
}
