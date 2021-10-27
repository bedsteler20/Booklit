// Dart imports:
import 'dart:convert';
import 'dart:io';

// Flutter imports:
import 'package:flutter/foundation.dart';

// Package imports:
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

// Project imports:
import 'package:plexlit/plexlit.dart';

export 'downloads_provider.io.dart' if (dart.library.html) 'downloads_provider.web.dart';

abstract class DownloadsProviderBase with ChangeNotifier {
  Map<MediaItem, double> inProgress = {};
  Map<MediaItem, CancelToken> cancelTokens = {};

  Future<void> init()async{}

  List<MediaItem> get downloaded =>
      STORAGE.downloadsIndex.values.map((e) => MediaItem.fromMap(e)).toList();

  void cancel(MediaItem item) {
    cancelTokens[item]?.cancel();
    inProgress.remove(item);
    notifyListeners();
  }

  void download(Audiobook book);

  void delete(String id);

  Future<Audiobook> getAudiobook(String id);
}
