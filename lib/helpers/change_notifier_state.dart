// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:plexlit/plexlit.dart';

abstract class ChangeNotifierState with ChangeNotifier {
  void setValue(VoidCallback _cb) {
    _cb();
    notifyListeners();
  }
}
