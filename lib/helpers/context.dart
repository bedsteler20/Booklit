// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:build_context/build_context.dart';
import 'package:provider/provider.dart';

export 'package:build_config/build_config.dart';

extension BuildContextExt on BuildContext {
  T find<T>({bool listen = false}) => Provider.of<T>(this, listen: listen);
  
  double get height => mediaQuerySize.height;
  double get width => mediaQuerySize.width;
}
