// Project imports:
import 'package:booklit/booklit.dart';
import 'package:booklit/model/bookmark.dart';

extension AudioProviderWithBookmarks on AudioProvider {
  void addBookmark([String? message]) {
    final List allBookmarks = STORAGE.bookmarks.get(current!.id, defaultValue: []);

    allBookmarks.add(Bookmark(
      position: position,
      message: message,
      chapterNumber: chapterIndex,
    ).toMap());

    STORAGE.bookmarks.put(current!.id, allBookmarks);
    setState();
  }

  List<Bookmark> get bookmarks {
    List data = STORAGE.bookmarks.get(current!.id, defaultValue: []);
    return [for (var i in data) Bookmark.fromMap(i)];
  }

  void removeBookmark(Bookmark bookmark) {
    List data = STORAGE.bookmarks.get(current!.id, defaultValue: []);
    data.removeWhere((e) => e["id"] == bookmark.id);
    STORAGE.bookmarks.put(current!.id, data);
    setState();
  }
}
