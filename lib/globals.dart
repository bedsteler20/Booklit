// Flutter imports:
import 'dart:io';

import 'package:flutter/material.dart';

// Package imports:
import 'package:miniplayer/miniplayer.dart';

// Project imports:
import 'package:plexlit/providers/api_provider.dart';
import 'package:plexlit/core/storage.dart';
import 'package:plexlit/providers/downloads_provider.dart';

final repository = RepoProvider();
final miniplayerController = MiniplayerController();
final storage = Storage();
final downloads = DownloadsProvider();
