// ignore_for_file: unused_element, non_constant_identifier_names
library Plex;

import 'package:dio/dio.dart';
import 'hubs.dart';

import 'account.dart';
import 'audio_book.dart';
import 'classes.dart';
import 'collections.dart';
import 'http.dart';
import 'library.dart';
import 'library_items_stream.dart';

abstract class Plex {
  static final Account = PlexAccount();

  static LibraryItemsStream libraryItemsStream() => LibraryItemsStream();
  static final Collections = CollectionMethods();

  static final library = Library();

  /// Gets a audio book by id Note: Makes multiple requsts to server to get all metadata on the AudioBook
  static Future<AudioBook> Function(int) audioBook = AudioBook.get;

  /// Gets all servers conected to the plex account
  static Future<List<PlexServer>> allServers() async {
    return await http.get(
      "https://plex.tv/api/v2/resources",
      queryParameters: {"includeHttps": 1, "includeRelay": 1},
    ).then((res) {
      List<PlexServer> i = [];
      for (var x in res.data) {
        if (x["provides"] == "server") i.add(PlexServer.fromApi(x));
      }
      return i;
    });
  }

  static Future<List<PlexLibrary>> allLibrarys() {
    return http.get("/library/sections").then((res) {
      List<PlexLibrary> i = [];
      for (var x in res.data["MediaContainer"]["Directory"]) {
        if (x["type"] == "artist") i.add(PlexLibrary.fromApi(x));
      }
      return i;
    });
  }

  static Uri audioFileUrl(String path) =>
      Uri.parse(Plex.Account.server! + path + "?X-Plex-Client-Identifier=${Plex.Account.clientID}&X-Plex-Token=${Plex.Account.token}");

  static Future<List<LibraryItem>> queryLibrary(String path, {Map<String, dynamic>? perams}) {
    return http.get(path, queryParameters: perams).then((res) => (res.data["MediaContainer"]["Metadata"] as Iterable)
        .map(
          (e) => LibraryItem.fromMap(e),
        )
        .toList());
  }
}
