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
    if (save) storage.saveClient(i);
    if (setPrimaryClient) storage.settings.put("primary_client", i.id);
    if (updateServerInfo) i.updateServerInfo();

    _repo = i;

    notifyListeners();
  }

  Future<void> loadPrimaryClient() async {
    String? primaryClientId = storage.settings.get("primary_client");
    if (primaryClientId == null) {
      await connect(await storage.loadClients().lastOrNull);
      return;
    }
    for (var item in storage.loadClients()) {
      if (item.id == primaryClientId) {
        await connect(item, updateServerInfo: true);
      }
    }
  }
}
