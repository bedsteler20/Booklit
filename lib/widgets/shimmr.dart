// Dart imports:
import 'dart:ui' as ui;

// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

enum ShimmrType {
  loop,
  yoyo,
}

class Shimmr extends StatefulWidget {
  final Duration duration;
  final BorderRadius borderRadius;
  final Color foregroundColor;
  final Color backgroundColor;
  final Duration delay;
  final ShimmrType shimmrType;

  static const _defaultDuration = Duration(seconds: 2);
  static const _defaultBorderRadius = BorderRadius.zero;
  static const _defaultColor = Colors.grey;
  static const _defaultBackgroundCOlor = Colors.transparent;
  static const _defaultDelayDuration = Duration.zero;
  static const _defaultShimmrType = ShimmrType.loop;

  Shimmr({
    this.duration = _defaultDuration,
    this.borderRadius = _defaultBorderRadius,
    this.foregroundColor = _defaultColor,
    this.backgroundColor = _defaultBackgroundCOlor,
    this.delay = _defaultDelayDuration,
    this.shimmrType = _defaultShimmrType,
  });

  @override
  _ShimmrState createState() => _ShimmrState();
}

class _ShimmrState extends State<Shimmr> with TickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController controller;
  late Animation<double> animation2;
  late AnimationController controller2;

  static void loopAnimation(AnimationController c, AnimationStatus s) {
    if (s == AnimationStatus.completed) {
      c.repeat();
    }
  }

  static void yoyoAnimation(AnimationController c, AnimationStatus s) {
    if (s == AnimationStatus.completed) {
      c.reverse();
    } else if (s == AnimationStatus.dismissed) {
      c.forward();
    }
  }

  @override
  void initState() {
    super.initState();
    controller = AnimationController(vsync: this, duration: widget.duration);

    controller2 = AnimationController(
        vsync: this, duration: Duration(milliseconds: widget.duration.inMilliseconds ~/ 2));

    animation = Tween<double>(begin: 0, end: 1).animate(controller)
      ..addListener(() => setState(() {}))
      ..addStatusListener((s) => widget.shimmrType == ShimmrType.loop
          ? loopAnimation(controller, s)
          : yoyoAnimation(controller, s));

    animation2 = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: controller2, curve: Curves.easeInSine))
      ..addListener(() => setState(() {}))
      ..addStatusListener((s) => yoyoAnimation(controller2, s));

    Future.delayed(widget.delay, () {
      controller.forward();
      controller2.forward();
    });
  }

  @override
  void dispose() {
    controller.dispose();
    controller2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: AnimatedBuilder(
        animation: animation,
        builder: (context, snapshot) {
          return ClipRRect(
            borderRadius: widget.borderRadius,
            child: Opacity(
              opacity: animation2.value,
              child: CustomPaint(
                painter: ShapePainter(
                  animation.value,
                  widget.foregroundColor,
                  widget.backgroundColor,
                ),
                child: Container(),
              ),
            ),
          );
        },
      ),
    );
  }
}

class ShapePainter extends CustomPainter {
  final double tick;
  final Color foregroundColor;
  final Color backgroundColor;

  ShapePainter(this.tick, this.foregroundColor, this.backgroundColor);

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(-size.width * 2, 0)
      ..lineTo(size.width * 3, 0)
      ..lineTo(size.width * 3, size.height)
      ..lineTo(-size.width * 2, size.height)
      ..close();

    final paint = Paint()
      ..style = PaintingStyle.fill
      ..shader = ui.Gradient.linear(
        size.centerLeft(Offset.zero),
        size.centerRight(Offset.zero),
        [
          backgroundColor,
          foregroundColor,
          backgroundColor,
        ],
        [0, tick, 1],
      );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
