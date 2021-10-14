// ignore_for_file: curly_braces_in_flow_control_structures

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:hive_flutter/hive_flutter.dart';
import 'package:plexlit_api/plexlit_api.dart';
import 'package:uuid/uuid.dart';

/// Manages Hive box's
class Storage {
  static late Box<Map<dynamic, dynamic>> plexClients;

  /// Stores the progress of audiobooks
  /// keys are the books id
  static late Box<int> progress;

  /// Stores API tokens
  static late Box _tokens;

  /// Used for random stuff and things
  static late Box _misc;

  static Future init() async {
    await Hive.initFlutter();
    progress = await Hive.openBox("progress");
    plexClients = await Hive.openBox("plex_clients");
    _misc = await Hive.openBox("misc");
    _tokens = await Hive.openBox("tokens");
    // plexClients.clear();
  }

  static List<PlexlitApiClient> loadClients() {
    List<PlexlitApiClient> _clients = [];
    for (var item in plexClients.values) _clients.add(PlexApi.fromMap(item));

    return _clients;
  }

  static void saveClient(PlexlitApiClient client) async {
    switch (client.runtimeType) {
      case PlexApi:
        plexClients.add(client.toMap());
        break;
      default:
        throw "Failed Saving Client Unknown Client Type";
    }
  }

  static String get clientId {
    if (_misc.containsKey("client_id")) {
      return _misc.get("client_id");
    } else {
      final v = const Uuid().v4();
      _misc.put("client_id", v);
      return v;
    }
  }

  String? getToken(String i) => _tokens.get(i, defaultValue: null);
  void saveToken(String key, String token) => _tokens.put(key, token);
}
