// Dart imports:
import 'dart:convert';
import 'dart:io';

// Flutter imports:
import 'package:flutter/cupertino.dart';

// Package imports:
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

// Project imports:
import 'package:plexlit/core/globals.dart';
import 'package:plexlit/helpers/dart.dart';
import 'package:plexlit/model/audiobook.dart';
import 'package:plexlit/model/media_item.dart';
import 'package:plexlit/plexlit.dart';

class DownloadsProvider with ChangeNotifier {
  Map<MediaItem, double> inProgress = {};
  Map<MediaItem, CancelToken> _cancelTokens = {};

  List<MediaItem> get downloaded =>
      storage.downloadsIndex.values.map((e) => MediaItem.fromMap(e)).toList();

  final _dio = Dio();

  void download(Audiobook book) async {
    final rootDirectory = (await getApplicationDocumentsDirectory()).path;
    final mediaItem = book.toMediaItem(offline: true)..type = MediaItemType.offlineAudiobook;
    final bookDir = await mkdir("$rootDirectory/downloads/${book.id}");
    final cancelToken = CancelToken();

    inProgress[mediaItem] = 0;
    _cancelTokens[mediaItem] = cancelToken;

    notifyListeners();

    if (book.chapterSource == ChapterSource.files) {
      for (var i = 0; i < book.chapters.length; i++) {
        // Download book
        await _dio.downloadUri(
          book.chapters[i].url,
          "$bookDir/$i.mp4",
          cancelToken: cancelToken,
          onReceiveProgress: (receivedBytes, totalBytes) {
            if (totalBytes != 1) {
              inProgress[mediaItem] = receivedBytes / totalBytes;
              notifyListeners();
            }
          },
        );
        book.chapters[i].url = Uri.parse("$bookDir/$i.m4b"); //TODO: add dynamic file extensions
      }
    } else {
      await _dio.downloadUri(
        book.chapters.first.url,
        "$bookDir/0.mp4",
        cancelToken: cancelToken,
        onReceiveProgress: (receivedBytes, totalBytes) {
          if (totalBytes != 1) {
            inProgress[mediaItem] = receivedBytes / totalBytes;
            notifyListeners();
          }
        },
      );

      book.chapters = book.chapters.map((e) => e..url = Uri.parse("$bookDir/0.mp4")).toList();
      inProgress.removeWhere((key, value) => key.id == mediaItem.id);
      notifyListeners();
    }

    // Download thumb
    if (book.thumb != null) {
      // TODO: add dynamic file extensions
      await _dio.downloadUri(
        book.thumb!,
        "$bookDir/thumb.png",
        cancelToken: cancelToken,
      );
      book.thumb = Uri.parse("$bookDir/thumb.png");
      mediaItem.thumb = Uri.parse("$bookDir/thumb.png");
    }

    // Metadata Saving
    final metadataFile = await File("$bookDir/metadata.json").create();

    await metadataFile.writeAsString(jsonEncode(book.toMap()));

    await storage.downloadsIndex.put(bookDir, mediaItem.toMap());

    notifyListeners();
  }

  void cancel(MediaItem item) {
    _cancelTokens[item]?.cancel();
    inProgress.remove(item);
    notifyListeners();
  }

  void delete(String id) async {
    final rootDirectory = (await getApplicationDocumentsDirectory()).path;
    final bookDir = await mkdir("$rootDirectory/downloads/$id");
    await Directory(bookDir).delete(recursive: true);
    storage.downloadsIndex.delete(bookDir);

    notifyListeners();
  }

  Future<Audiobook> getAudiobook(String id) async {
    final rootDirectory = (await getApplicationDocumentsDirectory()).path;

    final file = File("$rootDirectory/downloads/$id/metadata.json");
    return Audiobook.fromMap(jsonDecode(await file.readAsString()));
  }
}
