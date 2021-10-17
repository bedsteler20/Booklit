// ignore_for_file: curly_braces_in_flow_control_structures

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:hive_flutter/hive_flutter.dart';
import 'package:plexlit/repository/repository.dart';
import 'package:uuid/uuid.dart';

/// Manages Hive box's
class Storage {
   late Box<Map<dynamic, dynamic>> plexClients;

   late Box credentials;

  /// Stores the progress of audiobooks
  /// keys are the books id
   late Box progress;

  

   Future init() async {
    await Hive.initFlutter();
    progress = await Hive.openBox("progress");
    plexClients = await Hive.openBox("plex_clients");
    credentials=await Hive.openBox("credentials");
    // plexClients.clear();
  }

   List<PlexlitRepository> loadClients() {
    List<PlexlitRepository> _clients = [];
    for (var item in plexClients.values) _clients.add(PlexApi.fromMap(item));

    return _clients;
  }

   void saveClient(PlexlitRepository client) async {
    switch (client.runtimeType) {
      case PlexApi:
        plexClients.add(client.toMap());
        break;
      default:
        throw "Failed Saving Client Unknown Client Type";
    }
  }

}
