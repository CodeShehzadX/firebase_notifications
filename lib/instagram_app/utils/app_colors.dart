import 'package:flutter/material.dart';

/// Centralized color palette for the Instagram demo app.
class AppColors {
  AppColors._();

  static const Color background = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color white = Color(0xFFFFFFFF);

  /// Instagram action blue (Follow button, links).
  static const Color primary = Color(0xFF0095F6);

  static const Color grey = Color(0xFF8E8E8E);
  static const Color lightGrey = Color(0xFFDBDBDB);
  static const Color divider = Color(0xFFEFEFEF);

  /// "Following" button background.
  static const Color softGrey = Color(0xFFEFEFEF);

  static const Color red = Color(0xFFED4956);

  /// Preset background colors for text-only posts (5 swatches).
  static const List<int> postBackgrounds = [
    0xFF3897F0, // blue
    0xFFED4956, // red
    0xFF8134AF, // purple
    0xFF00897B, // teal
    0xFF262626, // dark
  ];

  /// Story ring gradient.
  static const List<Color> storyGradient = [
    Color(0xFFFEDA75),
    Color(0xFFFA7E1E),
    Color(0xFFD62976),
    Color(0xFF962FBF),
    Color(0xFF4F5BD5),
  ];
}
