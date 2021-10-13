import 'dart:async';
import 'dart:convert';
import 'dart:io';

import "package:dio/dio.dart";
import 'package:hive_flutter/hive_flutter.dart';
import '/api/library.dart';
import 'package:uuid/uuid.dart';

import '/api_classes.dart';

export '/api_classes.dart';

final deviceInfo = {
  "X-Plex-Version": "2.0",
  "X-Plex-Product": "Plexlit (Flutter)",
  "X-Plex-Model": "hosted",
  "X-Plex-Device": Platform.operatingSystem,
  "X-Plex-Device-Name": Platform.operatingSystem,
  "X-Plex-Sync-Version": "2",
  "X-Plex-Features": "external-media%2Cindirect-media",
};

class PlexApi {
  // int? libraryKey;

  // int? _authId;
  // String? _authCode;

  // final _client = Dio(BaseOptions(headers: ClientInfo.headers));

  // String? get token => _client.options.headers["X-Plex-Token"];
  // String? get clientId => _client.options.headers["X-Plex-Client-Identifier"];
  // String? get pmsUrl => _client.options.baseUrl;

  // set token(String? token) {
  //   if (token != null) _client.options.headers["X-Plex-Token"] = token;
  // }

  // set clientId(String? clientId) {
  //   if (clientId != null) _client.options.headers["X-Plex-Client-Identifier"] = clientId;
  // }

  // set pmsUrl(String? ip) {
  //   if (ip != null) {
  //     _client.options.baseUrl = ip;
  //   }
  // }

  // String transcodeImage(String url, {int? height, int? width}) =>
  //     "$pmsUrl/photo/:/transcode?width=$width&height=$height&minSize=1&upscale=1&url=$url&X-Plex-Client-Identifier=$clientId&X-Plex-Token=$token";

  // String image(String url) => "$pmsUrl$url&X-Plex-Client-Identifier=$clientId&X-Plex-Token=$token";

  /// Gets a audio book by id Note: Makes multiple requsts to server to get all metadata on the AudioBook

  ///Get Every thing in a users library
  Future<List<LibraryItem>> search({int size: 50, int startPosition: 0}) async {
    final result = await _client.get(
      "/library/sections/$libraryKey/search?type=9",
      queryParameters: {
        "X-Plex-Container-Start": startPosition.toString(),
        "X-Plex-Container-Size": size.toString(),
      },
    );

    List<LibraryItem> items = [];
    for (var item in result.data["MediaContainer"]["Metadata"]) {
      items.add(LibraryItem(
        ratingKey: int.parse(item["ratingKey"]),
        author: item["parentTitle"],
        thumb: item["thumb"] ?? "/:/resources/artist.png",
        title: item["title"],
      ));
    }

    return items;
  }

  Future<List<LibraryItem>> getCollection(int key) async {
    final result = await _client.get(
      "/library/collections/$key/children",
      queryParameters: {"excludeAllLeaves": 1},
    );

    List<LibraryItem> items = [];

    for (var item in result.data["MediaContainer"]["Metadata"]) {
      if (item["type"] == "album") {
        items.add(LibraryItem(
          ratingKey: int.parse(item["ratingKey"]),
          author: item["parentTitle"],
          thumb: item["thumb"] ?? "/:/resources/artist.png",
          title: item["title"],
        ));
      }
    }
    return items;
  }

  Future<List<Collection>?> getCollectins() async {
    try {
      final res = await _client.get(
        "/library/sections/$libraryKey/collections",
        queryParameters: {
          "includeCollections": 1,
          "includeExternalMedia": 1,
          "includeAdvanced": 1,
          "includeMeta": 1
        },
      );

      List<Collection> collections = [];

      for (var item in res.data["MediaContainer"]["Metadata"]) {
        collections.add(Collection(
            thumb: item["thumb"], title: item["title"], key: int.parse(item["ratingKey"])));
      }

      return collections;
    } catch (e) {
      print("Error Geting collections");
      return null;
    }
  }

  ///Note: Plex uses 0-10 for ratings with odd nembers represnting hafe stars
  //!BROKEN: darts URI class isnt phrasing the endpoints path because in contains ":"
  Future<void> rateItem(key, double userRating) async {
    await _client.putUri(
      Uri(path: "/:/rate", queryParameters: {
        "identifier": "com.plexapp.plugins.library",
        "key": key.toString(),
        "rating": userRating.toString(),
      }),
    );
  }

  Future<List<LibraryItem>> newItems() async {
    final res = await _client.get(
      "/hubs/sections/$libraryKey",
      queryParameters: {"count": 12},
    );

    List<LibraryItem> items = [];

    for (var item in res.data["MediaContainer"]["Hub"][1]["Metadata"]) {
      items.add(LibraryItem(
        author: item["parentTitle"],
        ratingKey: int.parse(item["ratingKey"]),
        thumb: item["thumb"] ?? "/:/resources/artist.png",
        title: item["title"],
      ));
    }

    return items;
  }

  Future<List<LibraryItem>> offlineLibrary() async {
    final lib = await Hive.openLazyBox("offline_library");
    List<LibraryItem> items = [];

    // Decode Library Items from Hive
    for (var key in lib.keys) {
      items.add(LibraryItem.fromMap(jsonDecode(await lib.get(key))));
    }

    return items;
  }

  /// Updates the progress of a Library Items playback with PMS
  /// Note: the ratingKey is for the file i think
  Future<void> updateProgress(String ratingKey, Duration duration) async {
    final updateUrl = Uri(path: "/:/progress", queryParameters: {
      "identifier": "com.plexapp.plugins.library",
      "key": ratingKey,
      "time": duration.inMilliseconds.toString(),
    });

    _client.getUri(updateUrl);
  }

  Future<List<Server>> getServers() async {
    final res = await _client.get(
      "https://plex.tv/api/v2/resources",
      queryParameters: {
        "includeHttps": 1,
        "includeRelay": 1,
      },
    );

    List<Server> servers = [];

    for (var device in res.data) {
      //Filter out all non servers
      if (device["provides"] == "server") {
        try {
          servers.add(Server(
            name: device["name"],
            url: device["connections"][1]["uri"] ?? "",
            serverId: device["clientIdentifier"] ?? "",
            ip: device["connections"][1]["address"] ?? "",
          ));
        } catch (_) {
          servers.add(Server(
            name: device["name"],
            url: device["connections"][0]["uri"],
            serverId: device["clientIdentifier"],
            ip: device["connections"][0]["address"],
          ));
        }
      }
    }

    return servers;
  }

  Future<List<PlexLibrary>> getLibrarys() async {
    final librarys = (await _client.get("/library/sections")).data["MediaContainer"]["Directory"];
    List<PlexLibrary> audioLibrarys = [];

    for (var library in librarys) {
      if (library["type"] == "artist") {
        audioLibrarys.add(PlexLibrary(
          title: library["title"],
          key: int.parse(library["key"]),
        ));
      }
    }
    return audioLibrarys;
  }
}
