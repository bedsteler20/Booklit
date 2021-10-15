// Flutter imports:
import 'package:flutter/material.dart';

const _background = Color.fromARGB(255, 32, 26, 28);

materialYouTheme() => ThemeData(
    // brightness: Brightness.dark,
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
    ));
