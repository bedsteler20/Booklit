import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'package:plexlit/model/audiobook.dart';

class DownloadsProvider with ChangeNotifier {
  Map<Audiobook, ValueNotifier<double>> inProgress = {};
  final _dio = Dio();

  void download(Audiobook book) async {
    final basePath = await getApplicationDocumentsDirectory();

    final bookDir = await Directory("${basePath.path}/${book.id}").create();
    inProgress[book] = ValueNotifier(0);
    notifyListeners();
    if (book.chapterSource == ChapterSource.files) {
      var totalProgress = 0.0;
      for (var i = 0; i < book.chapters.length; i++) {
        book.chapters[i].url = Uri.parse("$bookDir/$i.mp4");

        // Download book
        await _dio.downloadUri(
          book.chapters[i].url,
          "$bookDir/$i.mp4",
          onReceiveProgress: (receivedBytes, totalBytes) {
            if (totalBytes != 1) {
              totalProgress = receivedBytes / totalBytes * 100;
              inProgress[book]!.value = totalProgress / book.chapters.length;
              print("${(receivedBytes / totalBytes * 100).round()}%");
            }
          },
        );
        print("Completed");
      }
    } else {
      book.chapters =
          book.chapters.map((e) => e..url = Uri.parse("${basePath.path}/0.mp4")).toList();

      await _dio.downloadUri(
        book.chapters.first.url,
        "${basePath.path}/0.mp4",
        onReceiveProgress: (receivedBytes, totalBytes) {
          if (totalBytes != 1) {
            inProgress[book]!.value = receivedBytes / totalBytes * 100;
            print("${(receivedBytes / totalBytes * 100).round()}%");
          }
        },
      );
    }
  }
}
