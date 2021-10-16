// Flutter imports:
import 'package:flutter/material.dart';
import 'package:plexlit/globals.dart';
import 'package:plexlit/repository/repository.dart';

// Package imports:

// Project imports:

class Repo with ChangeNotifier {
  PlexlitApiClient? _repo;

  PlexlitApiClient? get data => _repo;

  bool get hasClient => _repo != null;

  void connect(PlexlitApiClient? i, {bool save = true}) {
    if (i == null) return;
    _repo = i;
    if (save) storage.saveClient(i);
    notifyListeners();
  }
}
