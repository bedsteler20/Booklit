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

  Future<void> connect(
    PlexlitRepository? i, {
    bool save = true,
    bool setPrimaryClient = false,
    bool updateServerInfo = false,
  }) async {
    if (i == null) return;
    if (save) STORAGE.saveClient(i);
    if (setPrimaryClient) STORAGE.settings.put("primary_client", i.clientId);
    if (updateServerInfo) i.updateServerInfo();

    _repo = i;

    notifyListeners();
  }

  Future<void> loadPrimaryClient() async {
    String? primaryClientId = STORAGE.settings.get("primary_client");
    if (primaryClientId == null) {
      await connect(await STORAGE.loadClients().lastOrNull);
      return;
    }
    for (var item in STORAGE.loadClients()) {
      if (item.clientId == primaryClientId) {
        await connect(item, updateServerInfo: true);
      }
    }
  }
}
