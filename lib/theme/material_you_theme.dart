// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:plexlit/plexlit.dart';

const _background = Color.fromARGB(255, 32, 26, 28);

final materialYouTheme = ThemeData(
    buttonColor: const Color.fromARGB(255, 255, 175, 210),
    cardColor: const Color.fromARGB(255, 43, 33, 37),
    cardTheme: CardTheme(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
    primaryColor: const Color.fromARGB(255, 255, 175, 210),
    colorScheme: const ColorScheme.dark(
      primary: Color.fromARGB(255, 255, 175, 210),
      secondary: Color.fromARGB(255, 255, 175, 210),
      background: _background,
    ),
    scaffoldBackgroundColor: const Color.fromARGB(255, 32, 26, 28),
    navigationBarTheme: const NavigationBarThemeData(
      backgroundColor: Color.fromARGB(255, 50, 39, 42),
      indicatorColor: Color.fromARGB(255, 195, 162, 175),
    ),
    navigationRailTheme: const NavigationRailThemeData(
      backgroundColor: Color.fromARGB(255, 50, 39, 42),
      selectedIconTheme: IconThemeData(color: Color.fromARGB(255, 255, 175, 210)),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: _background,
      elevation: 0,
    ),
    popupMenuTheme: PopupMenuThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
    dialogTheme: const DialogTheme(
      backgroundColor: _background,
    ));
