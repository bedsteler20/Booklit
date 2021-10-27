@JS()
library plexlit_js_lib;

// Dart imports:
import 'dart:async';

// Package imports:
import 'package:js/js.dart';

@JS()
external Future download(String id, List<String> urls);
