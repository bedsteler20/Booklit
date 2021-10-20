// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:plexlit/plexlit.dart';

/// Generate a theme.
class GThemeGenerator {
  static const ColorScheme _colorScheme = ColorScheme(
    primary: Color(0xFF1A73E9),
    primaryVariant: Color(0xFF1D62D6),
    secondary: Color(0xFF1A73E9),
    secondaryVariant: Color(0xFF1D62D6),
    surface: Colors.white,
    background: Colors.white,
    error: Color(0xFFC6074A),
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onSurface: Color(0xFF3C4043),
    onBackground: Color(0xFF3C4043),
    onError: Colors.white,
    brightness: Brightness.light,
  );

  static const ColorScheme _darkColorScheme = ColorScheme(
    primary: Color(0xFF89B4F8),
    primaryVariant: Color(0xFFA6C9FC),
    secondary: Color(0xFF89B4F8),
    secondaryVariant: Color(0xFFA6C9FC),
    surface: Color(0xFF303135),
    background: Color(0xFF202125),
    error: Color(0xFFC6074A),
    onPrimary: Color(0xFF202125),
    onSecondary: Color(0xFF202125),
    onSurface: Colors.white,
    onBackground: Colors.white,
    onError: Colors.white,
    brightness: Brightness.dark,
  );

  static const _textTheme = TextTheme(
    headline1: TextStyle(
      fontSize: 93,
      fontWeight: FontWeight.w300,
      letterSpacing: -1.5,
    ),
    headline2: TextStyle(
      fontSize: 58,
      fontWeight: FontWeight.w300,
      letterSpacing: -0.5,
    ),
    headline3: TextStyle(
      fontSize: 46,
      fontWeight: FontWeight.w400,
    ),
    headline4: TextStyle(
      fontSize: 33,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.25,
    ),
    headline5: TextStyle(
      fontSize: 23,
      fontWeight: FontWeight.w400,
    ),
    headline6: TextStyle(
      fontSize: 19,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.15,
    ),
    subtitle1: TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.15,
    ),
    subtitle2: TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.1,
    ),
    bodyText1: TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.5,
    ),
    bodyText2: TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.25,
    ),
    button: TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w500,
      letterSpacing: 1.25,
    ),
    caption: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.4,
    ),
    overline: TextStyle(
      fontSize: 10,
      fontWeight: FontWeight.w400,
      letterSpacing: 1.5,
    ),
  );

  /// Generate a theme, if [colorScheme] is null, default light [colorScheme] used.
  static ThemeData generate({ColorScheme? colorScheme}) {
    return _generateThemeData(colorScheme ?? _colorScheme);
  }

  /// Generate a dark theme using default dark [colorScheme].
  static ThemeData generateDark() {
    return _generateThemeData(_darkColorScheme);
  }

  static ThemeData _generateThemeData(ColorScheme colorScheme) {
    return ThemeData(
      visualDensity: VisualDensity.standard,
      fontFamily: "Poppins",
      colorScheme: colorScheme,
      primaryColor: colorScheme.primary,
      indicatorColor: colorScheme.primary,
      toggleableActiveColor: colorScheme.primary,
      scaffoldBackgroundColor: colorScheme.background,
      popupMenuTheme: PopupMenuThemeData(color: colorScheme.surface),
      dialogBackgroundColor: colorScheme.surface,
      iconTheme: IconThemeData(color: colorScheme.onBackground),
      textTheme: _textTheme.apply(
        displayColor: colorScheme.onBackground,
        bodyColor: colorScheme.onBackground,
        decorationColor: colorScheme.onBackground,
      ),
      dividerColor: colorScheme.onBackground.withOpacity(.25),
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: colorScheme.onBackground.withOpacity(.75),
          borderRadius: BorderRadius.circular(4),
        ),
      ),
      appBarTheme: AppBarTheme(
        titleTextStyle: _textTheme.headline6?.copyWith(
          fontWeight: FontWeight.normal,
          color: colorScheme.onSurface,
        ),
        backgroundColor: colorScheme.surface,
        iconTheme: IconThemeData(color: colorScheme.onSurface),
        shadowColor: colorScheme.brightness == Brightness.light ? Colors.white70 : Colors.black45,
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: colorScheme.surface,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        type: BottomNavigationBarType.fixed,
        backgroundColor: colorScheme.surface,
        unselectedItemColor: colorScheme.onSurface.withOpacity(.75),
        selectedLabelStyle: _textTheme.bodyText2?.copyWith(
          fontWeight: FontWeight.w500,
        ),
        unselectedLabelStyle: _textTheme.bodyText2?.copyWith(
          fontWeight: FontWeight.w500,
        ),
      ),
      tabBarTheme: TabBarTheme(
        labelColor: colorScheme.primary,
        unselectedLabelColor: colorScheme.onSurface.withOpacity(.75),
        indicator: GTabBarIndicator(colorScheme.primary),
        indicatorSize: TabBarIndicatorSize.label,
      ),
      inputDecorationTheme: const InputDecorationTheme(
        isDense: true,
        border: OutlineInputBorder(),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: MaterialStateColor.resolveWith(
            (states) => colorScheme.primary,
          ),
          overlayColor: MaterialStateColor.resolveWith(
            (states) => Colors.black.withOpacity(.25),
          ),
          elevation: MaterialStateProperty.resolveWith(
            (states) {
              const pressedState = MaterialState.pressed;
              const hoveredState = MaterialState.hovered;
              final isHoveredOrPressed = states.where((e) => e == pressedState || e == hoveredState).isNotEmpty;

              if (isHoveredOrPressed) return 3;
              return 0;
            },
          ),
          tapTargetSize: MaterialTapTargetSize.padded,
        ),
      ),
      textButtonTheme: const TextButtonThemeData(
        style: ButtonStyle(
          tapTargetSize: MaterialTapTargetSize.padded,
        ),
      ),
      outlinedButtonTheme: const OutlinedButtonThemeData(
        style: ButtonStyle(tapTargetSize: MaterialTapTargetSize.padded),
      ),
    );
  }
}

class GTabBarIndicator extends Decoration {
  const GTabBarIndicator(this.color);

  final Color color;

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _GTabBarIndicatorPainter(color);
  }
}

class _GTabBarIndicatorPainter extends BoxPainter {
  const _GTabBarIndicatorPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    final Paint paint = Paint();
    paint.color = color;
    paint.style = PaintingStyle.fill;

    const double height = 3;
    const double borderRadius = 8;

    final rect = Offset(
          offset.dx,
          configuration.size!.height - height,
        ) &
        Size(
          configuration.size!.width,
          height,
        );

    canvas.drawRRect(
      RRect.fromRectAndCorners(
        rect,
        topRight: const Radius.circular(borderRadius),
        topLeft: const Radius.circular(borderRadius),
      ),
      paint,
    );
  }
}
