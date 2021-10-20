// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:plexlit/plexlit.dart';

class FutureBuilderPlus<T> extends StatelessWidget {
  const FutureBuilderPlus({
    Key? key,
    required this.future,
    required this.completed,
    required this.loading,
    required this.error,
  }) : super(key: key);

  final Widget Function(BuildContext context) loading;
  final Widget Function(BuildContext context, T value) completed;
  final Widget Function(BuildContext context, Object? error) error;
  final Future<T> future;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
      future: future,
      key: key,
      builder: (ctx, snap) {
        if (snap.hasError) {
          return error(ctx, snap.error);
        } else if (snap.hasData) {
          return completed(ctx, snap.data!);
        } else {
          return loading(ctx);
        }
      },
    );
  }
}

class RoundedBorder extends StatelessWidget {
  const RoundedBorder(
      {required this.radius,
      this.elevation = 0,
      Key? key,
      this.height,
      this.width,
      this.padding,
      required this.child})
      : super(key: key);
  final double radius;
  final Widget child;
  final double elevation;
  final double? height;
  final double? width;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: Material(
          borderRadius: BorderRadius.circular(radius),
          elevation: elevation,
          child: SizedBox(
            width: width,
            height: height,
            child: child,
          ),
        ),
      ),
    );
  }
}

class RowContainer extends StatelessWidget {
  const RowContainer({
    Key? key,
    this.color,
    this.decoration,
    this.foregroundDecoration,
    this.width,
    this.height,
    this.constraints,
    this.margin,
    this.transform,
    this.transformAlignment,
    this.clipBehavior = Clip.none,
    this.alignment,
    this.padding,

// -------------Row props---------------------
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.mainAxisSize = MainAxisSize.max,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.textDirection,
    this.verticalDirection = VerticalDirection.down,
    this.textBaseline,
    this.children = const <Widget>[],
  }) : super(key: key);
  final Color? color;
  final Decoration? decoration;
  final Decoration? foregroundDecoration;
  final double? width;
  final double? height;
  final BoxConstraints? constraints;
  final EdgeInsetsGeometry? margin;
  final Matrix4? transform;
  final AlignmentGeometry? transformAlignment;
  final Clip clipBehavior;
  final AlignmentGeometry? alignment;
  final EdgeInsetsGeometry? padding;

// -------------Row props----------------------
  final MainAxisAlignment mainAxisAlignment;
  final MainAxisSize mainAxisSize;
  final CrossAxisAlignment crossAxisAlignment;
  final TextDirection? textDirection;
  final VerticalDirection verticalDirection;
  final TextBaseline? textBaseline;
  final List<Widget> children;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
      decoration: decoration,
      foregroundDecoration: foregroundDecoration,
      width: width,
      height: height,
      constraints: constraints,
      margin: margin,
      transform: transform,
      transformAlignment: transformAlignment,
      alignment: alignment,
      padding: padding,
      child: Row(
        mainAxisSize: mainAxisSize,
        crossAxisAlignment: crossAxisAlignment,
        textDirection: textDirection,
        verticalDirection: verticalDirection,
        textBaseline: textBaseline,
        children: children,
      ),
    );
  }
}

class ColumnContainer extends StatelessWidget {
  ColumnContainer({
    Key? key,
    this.color,
    this.decoration,
    this.foregroundDecoration,
    this.width,
    this.height,
    this.constraints,
    this.margin,
    this.transform,
    this.transformAlignment,
    this.clipBehavior = Clip.none,
    this.alignment,
    this.padding,

// -------------Row props---------------------
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.mainAxisSize = MainAxisSize.max,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.textDirection,
    this.verticalDirection = VerticalDirection.down,
    this.textBaseline,
    this.children = const <Widget>[],
  }) : super(key: key);
  Color? color;
  Decoration? decoration;
  Decoration? foregroundDecoration;
  double? width;
  double? height;
  BoxConstraints? constraints;
  EdgeInsetsGeometry? margin;
  Matrix4? transform;
  AlignmentGeometry? transformAlignment;
  Clip clipBehavior;
  AlignmentGeometry? alignment;
  EdgeInsetsGeometry? padding;

// -------------Row props----------------------
  MainAxisAlignment mainAxisAlignment;
  MainAxisSize mainAxisSize;
  CrossAxisAlignment crossAxisAlignment;
  TextDirection? textDirection;
  VerticalDirection verticalDirection;
  TextBaseline? textBaseline;
  List<Widget> children;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
      decoration: decoration,
      foregroundDecoration: foregroundDecoration,
      width: width,
      height: height,
      constraints: constraints,
      margin: margin,
      transform: transform,
      transformAlignment: transformAlignment,
      alignment: alignment,
      padding: padding,
      child: Column(
        mainAxisSize: mainAxisSize,
        crossAxisAlignment: crossAxisAlignment,
        textDirection: textDirection,
        verticalDirection: verticalDirection,
        textBaseline: textBaseline,
        children: children,
      ),
    );
  }
}

class If extends StatelessWidget {
  const If({required this.condition, this.$true, this.$else, Key? key}) : super(key: key);
  final Widget? $true;
  final Widget? $else;
  final bool condition;

  @override
  Widget build(BuildContext context) {
    if (condition) {
      return $true ?? Container();
    } else {
      return $else ?? Container();
    }
  }
}
