import 'package:flutter/material.dart';
import 'color_styles.dart';

/*
|--------------------------------------------------------------------------
| Dark Theme Colors
|--------------------------------------------------------------------------
*/

class DarkThemeColors implements ColorStyles {
  // general
  Color get background => const Color(0xFF0F1828);

  Color get primaryContent => const Color(0xFFF7F7FC);
  Color get primaryAccent => const Color(0xFF9999aa);

  Color get surfaceBackground => Colors.white70;
  Color get surfaceContent => Colors.black;

  // app bar
  Color get appBarBackground => const Color(0xFF4b5e6d);
  Color get appBarPrimaryContent => Colors.white;

  // buttons
  Color get buttonBackground => const Color(0xFF375FFF);
  Color get buttonPrimaryContent => const Color(0xFFF7F7FC);

  // bottom tab bar
  Color get bottomTabBarBackground => const Color(0xFF232c33);

  // bottom tab bar - icons
  Color get bottomTabBarIconSelected => Colors.white70;
  Color get bottomTabBarIconUnselected => Colors.white60;

  // bottom tab bar - label
  Color get bottomTabBarLabelUnselected => Colors.white54;
  Color get bottomTabBarLabelSelected => Colors.white;
}
