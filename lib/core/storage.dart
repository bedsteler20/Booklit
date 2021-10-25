// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';

// Project imports:
import 'package:plexlit/plexlit.dart';
import 'package:plexlit/repository/base_repository.dart';

// ignore_for_file: curly_braces_in_flow_control_structures

/// Manages Hive box's
class Storage {
  late Box<Map<dynamic, dynamic>> plexClients;

  late Box settings;
  late Box accounts;

  /// Stores the progress of audiobooks
  /// keys are the books id
  late Box progress;

  late Box downloadsIndex;

  Future init() async {
    await Hive.initFlutter();
    progress = await Hive.openBox("progress");
    plexClients = await Hive.openBox("plex_clients");
    accounts = await Hive.openBox("accounts");
    downloadsIndex = await Hive.openBox("downloads_index");
    settings = await Hive.openBox("settings");
    // plexClients.clear();
  }

  List<PlexlitRepository> loadClients() {
    List<PlexlitRepository> _clients = [];
    for (var item in plexClients.values) _clients.add(PlexRepository.fromMap(item));

    return _clients;
  }

  void saveClient(PlexlitRepository client) async {
    switch (client.runtimeType) {
      case PlexRepository:
        plexClients.put(client.clientId, client.toMap());
        break;
      default:
        throw "Failed Saving Client Unknown Client Type";
    }
  }
}
