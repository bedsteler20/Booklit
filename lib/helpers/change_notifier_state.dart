import 'package:plexlit/plexlit.dart';
// Flutter imports:
import 'package:flutter/material.dart';

abstract class ChangeNotifierState with ChangeNotifier {
  void setValue(VoidCallback _cb) {
    _cb();
    notifyListeners();
  }
}
