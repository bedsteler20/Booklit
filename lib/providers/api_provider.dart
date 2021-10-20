// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:plexlit/core/globals.dart';
import 'package:plexlit/plexlit.dart';
import 'package:plexlit/repository/base_repository.dart';

// Package imports:

// Project imports:

class RepoProvider with ChangeNotifier {
  PlexlitRepository? _repo;

  PlexlitRepository? get data => _repo;

  bool get hasClient => _repo != null;

  void connect(PlexlitRepository? i, {bool save = true}) {
    if (i == null) return;
    _repo = i;
    if (save) storage.saveClient(i);
    notifyListeners();
  }
}
