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
import 'package:plexlit/globals.dart';
import 'package:plexlit/helpers/dart.dart';
import 'package:plexlit/model/audiobook.dart';
import 'package:plexlit/model/media_item.dart';
import 'package:plexlit/plexlit.dart';

class DownloadsProvider with ChangeNotifier {
  Map<MediaItem, ValueNotifier<double>> inProgress = {};
  final _dio = Dio();

  static _pathSanitizer(String path) => path.replaceAll(" ", "_").toLowerCase();

  void download(Audiobook book) async {
    final rootDirectory = (await getApplicationDocumentsDirectory()).path;

    final mediaItem = book.toMediaItem(offline: true)..type = MediaItemType.offlineAudiobook;

    inProgress[mediaItem] = ValueNotifier(0);

    final bookDir = await mkdir("$rootDirectory/downloads/${book.id}");

    notifyListeners();

    if (book.chapterSource == ChapterSource.files) {
      var totalProgress = 0.0;

      for (var i = 0; i < book.chapters.length; i++) {
        // Download book
        await _dio.downloadUri(
          book.chapters[i].url,
          "$bookDir/$i.mp4",
          onReceiveProgress: (receivedBytes, totalBytes) {
            if (totalBytes != 1) {
              inProgress[mediaItem]!.value = receivedBytes / totalBytes;
            }
          },
        );
        book.chapters[i].url = Uri.parse("$bookDir/$i.m4b"); //TODO: add dynamic file extensions
      }
    } else {
      await _dio.downloadUri(
        book.chapters.first.url,
        "$bookDir/0.mp4",
        onReceiveProgress: (receivedBytes, totalBytes) {
          if (totalBytes != 1) {
            inProgress[mediaItem]!.value = receivedBytes / totalBytes;
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
      await _dio.downloadUri(book.thumb!, "$bookDir/thumb.png");
      book.thumb = Uri.parse("$bookDir/thumb.png");
      mediaItem.thumb = Uri.parse("$bookDir/thumb.png");
    }

    // Metadata Saving
    final metadataFile = await File("$bookDir/metadata.json").create();

    await metadataFile.writeAsString(jsonEncode(book.toMap()));

    await storage.downloadsIndex.put(bookDir, mediaItem.toMap());
  }

  Future<List<MediaItem>> savedAudiobooks() async => [
        for (var item in storage.downloadsIndex.keys)
          MediaItem.fromMap(await storage.downloadsIndex.get(item))
      ];

  Future<Audiobook> getAudiobook(String id) async {
    final rootDirectory = (await getApplicationDocumentsDirectory()).path;

    final file = File("$rootDirectory/downloads/$id/metadata.json");
    return Audiobook.fromMap(jsonDecode(await file.readAsString()));
  }
}
