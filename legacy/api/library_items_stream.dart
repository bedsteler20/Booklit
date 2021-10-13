import 'dart:async';

import 'classes.dart';
import 'http.dart';

import 'api.dart';

// TODO: Debug
class LibraryItemsStream {
  final int containerSize = 25;

  int? totalItems; // The amout of items in the plex library
  int get length => items.length; // How many items have been feched
  bool isLoading = false;
  List<LibraryItem> items = [];

  Future<void> dispose() async {
    await _controlor.close();
    items = [];
    isLoading = false;
    totalItems = null;
  }

  Future<void> getMore() async {
    if (isLoading) return;

    if (totalItems == length) return;

    isLoading = true;

    try {
      // Get json from PMS
      final res = await http.get(
        Plex.Account.library! + "/search",
        queryParameters: {
          "type": 9,
          "X-Plex-Container-Start": length,
          "X-Plex-Container-Size": containerSize,
        },
      );

      final mediaContainer = res.data["MediaContainer"];
      final List metadata = mediaContainer["Metadata"];

      // Olny sets total items when this future is first called
      // if the server dosnt provide the total number of items
      // than asume the total number of is 0
      totalItems ??= mediaContainer["totalSize"] ?? 0;

      // phrase responce from server as LibraryItems and
      // add them to the stream
      items.addAll(metadata
          .map(
            (e) => LibraryItem(
              ratingKey: int.parse(e["ratingKey"]),
              author: e["parentTitle"],
              thumb: e["thumb"],
              title: e["title"],
            ),
          )
          .toList());

      _controlor.sink.add(0);

      // Stop stream if all items have been fetched
      if (totalItems == length) _controlor.close();
    } catch (e) {
      _controlor.addError(e);
      _controlor.close();
    }
    isLoading = false;
  }

  final _controlor = StreamController<int>();
  Stream<int> get stream => _controlor.stream.asBroadcastStream();

  static Future<List<LibraryItem>> getAll() async {
    List<LibraryItem> items = [];
    int totalItems = 0;
    // Get json from PMS
    final res = await http.get(
      Plex.Account.library! + "/search",
      queryParameters: {
        "type": 9,
        "X-Plex-Container-Start": items.length,
        "X-Plex-Container-Size": 50,
      },
    );

    final mediaContainer = res.data["MediaContainer"];
    final List metadata = mediaContainer["Metadata"];

    totalItems = mediaContainer["totalSize"] ?? 0;

    for (var e in metadata) {
      items.add(LibraryItem(
        ratingKey: int.parse(e["ratingKey"]),
        author: e["parentTitle"],
        thumb: e["thumb"] ?? "/:/resources/artist.png",
        title: e["title"],
      ));
    }

    // for (items.length != totalItems;;) {
    //   final res = await Http.get(
    //     Plex.Account.library! + "/search",
    //     queryParameters: {
    //       "type": 9,
    //       "X-Plex-Container-Start": items.length,
    //       "X-Plex-Container-Size": 50,
    //     },
    //   );

    //   for (var e in res.data["MediaContainer"]["Metadata"]) {
    //     items.add(LibraryItem(
    //       ratingKey: int.parse(e["ratingKey"]),
    //       author: e["parentTitle"],
    //       thumb: e["thumb"] ?? "/:/resources/artist.png",
    //       title: e["title"],
    //     ));
    //   }
    // }
    return items;
  }
}
