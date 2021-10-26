// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:plexlit/plexlit.dart';

abstract class ChangeNotifierState with ChangeNotifier {
  void setState([VoidCallback? _cb]) {
    _cb?.call();
    notifyListeners();
  }

  /// Saves state to disk
  Future<void> saveState() async {}

  /// Loads State from disk
  Future<void> loadState() async {}

  Future<void> initState() async {
    loadState();
  }
}
