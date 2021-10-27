// Dart imports:
// ignore_for_file: avoid_web_libraries_in_flutter

// Dart imports:
import 'dart:js_util';

// Package imports:
import 'package:hive_flutter/hive_flutter.dart';

// Project imports:
import 'package:plexlit/helpers/plexlit_js_lib.web.dart' as jslib;
import 'package:plexlit/plexlit.dart';

// Project imports:

class DownloadsProvider extends DownloadsProviderBase {
  // final _platformInterface = js.JsObject.fromBrowserObject(js.context['downloadProvider']);
  late LazyBox _metadata;

  @override
  Future<void> init() async {
    _metadata = await Hive.openLazyBox("metadata");
  }

  @override
  void download(Audiobook book) async {
    final mediaItem = book.toMediaItem(offline: true)..type = MediaItemType.offlineAudiobook;

    List<String> urls = ["dsafad"];

    if (book.chapterSource == ChapterSource.files) {
      for (var item in book.chapters) {
        urls.addAll(book.chapters.map((e) => e.url.toString()).toList());
      }
    } else {
      urls.add(book.chapters.first.url.toString());
    }

    if (book.thumb != null) urls.add(book.thumb.toString());

    await promiseToFuture(jslib.download(book.id, urls));
    await STORAGE.downloadsIndex.put(book.id, mediaItem.toMap());
    await _metadata.put(book.id, book.toMap());

    notifyListeners();
  }

  void delete(String id) async {
    throw UnimplementedError();
  }

  Future<Audiobook> getAudiobook(String id) async {
    return Audiobook.fromMap(await _metadata.get(id));
  }
}
