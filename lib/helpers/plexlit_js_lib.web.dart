@JS()
library plexlit_js_lib;

import 'package:js/js.dart';
import 'dart:async';

@JS()
external Future download(String id, List<String> urls);