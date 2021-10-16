// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:miniplayer/miniplayer.dart';

// Project imports:
import 'package:plexlit/providers/api_provider.dart';

final repository = Repo();
final miniPlayer = MiniplayerController();

abstract class Keys {
  static final scaffold = GlobalKey<ScaffoldMessengerState>();
}
