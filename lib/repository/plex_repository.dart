// Dart imports:
// ignore_for_file: overridden_fields

// Dart imports:
import 'dart:async';
import 'dart:io';

// Flutter imports:
import 'package:flutter/foundation.dart';

// Package imports:
import 'package:dio/dio.dart';
import 'package:uuid/uuid.dart';

// Project imports:
import 'package:plexlit/plexlit.dart';

class PlexRepository extends PlexlitRepository {
  String token;
  PlexDevice server;
  @override
  String clientId;
  MediaItem library;

  @override
  String get title => library.title;

  @override
  String? get title2 => "${server.name} - ${server.publicAddress}";

  String get libraryId => library.id;

  final _dio = Dio();
  static const type = PlexlitClientType.plex;

  /// Asks Plex.tv for a list of servers and picks the one thats client id matches
  static Future<List<PlexDevice>> findServers({
    required String clientId,
    required String token,
  }) async {
    print("Getting Plex Servers");

    return await Dio(
      BaseOptions(
        headers: {
          "X-Plex-Version": "2.0",
          "X-Plex-Product": "Plexlit",
          "X-Plex-Model": "hosted",
          "X-Plex-Device": kIsWeb ? "Web" : Platform.operatingSystem,
          "X-Plex-Device-Name": kIsWeb ? "Web" : Platform.localHostname,
          "X-Plex-Sync-Version": "2",
          "X-Plex-Features": "external-media%2Cindirect-media",
          "X-Plex-Client-Identifier": clientId,
          "X-Plex-Token": token,
          "accept": "application/json",
        },
      ),
    ).get(
      "https://plex.tv/api/v2/resources",
      queryParameters: {"includeHttps": 1, "includeRelay": 1},
    ).then((v) => (v.data as List)
        // Filter out all non servers
        .map((e) => PlexDevice.fromMap(e))
        .toList()
        .where((z) => z.provides == "server")
        .toList());
  }

  String get libraryAddress => "${server.address}/library/sections/$libraryId";

  PlexRepository({
    required this.server,
    required this.token,
    required this.library,
    required this.clientId,
  }) {
    _dio.options = BaseOptions(
      headers: {
        "X-Plex-Token": token,
        "X-Plex-Client-Identifier": clientId,
        "X-Plex-Version": "2.0",
        "X-Plex-Product": "Plexlit",
        "X-Plex-Model": "hosted",
        "X-Plex-Device": kIsWeb ? "Web" : Platform.operatingSystem,
        "X-Plex-Device-Name": kIsWeb ? "Web" : Platform.localHostname,
        "X-Plex-Sync-Version": "2",
        "X-Plex-Features": "external-media%2Cindirect-media",
        "accept": "application/json",
      },
    );
  }

  @override
  getAudiobooks({int start = 0, int limit = 50}) async => _dio.get(
        "$libraryAddress/all?type=9",
        queryParameters: {
          "X-Plex-Container-Start": start,
          "X-Plex-Container-Size": limit,
        },
      ).then((_) => makeMediaList(_));

  @override
  getCollections({int start = 0, int limit = 50}) async => _dio.get(
        "$libraryAddress/collections",
        queryParameters: {
          "X-Plex-Container-Start": start,
          "X-Plex-Container-Size": limit,
        },
      ).then(makeMediaList);
  @override
  getCollection(String id, {int start = 0, int limit = 50}) async => _dio.get(
        "${server.address}/library/collections/$id/children",
        queryParameters: {
          "type": 9,
          "X-Plex-Container-Start": start,
          "X-Plex-Container-Size": limit,
        },
      ).then(makeMediaList);
  @override
  getGenres({int start = 0, int limit = 50}) async => _dio.get(
        "$libraryAddress/genre",
        queryParameters: {
          "type": 9,
          "X-Plex-Container-Start": start,
          "X-Plex-Container-Size": limit,
        },
      ).then(makeMediaList);
  @override
  getGenre(String id, {int start = 0, int limit = 50}) async => _dio.get(
        "$libraryAddress/all",
        queryParameters: {
          "type": 9,
          "genre": id,
          "X-Plex-Container-Start": start,
          "X-Plex-Container-Size": limit,
        },
      ).then(makeMediaList);

  @override
  getAudioBook(String id) async {
    const queryParameters = {
      "includeChapters": "1",
      "includeReviews": "1",
      "includeCollections": "1",
    };

    // This endpoint gets collections and userRatings
    final album = await _dio.get("${server.address}/library/metadata/$id", queryParameters: {
      "includeChapters": "1",
      "includeReviews": "1",
      "includeCollections": "1",
    }).then((e) => e.data["MediaContainer"]["Metadata"][0]);

    final track = (await _dio.get(
      "${server.address}/library/metadata/$id/children",
      queryParameters: {
        "includeChapters": "1",
        "includeReviews": "1",
        "includeCollections": "1",
      },
    ))
        .data["MediaContainer"]["Metadata"] as List;

    Future<List<Chapter>> chapters() async {
      if (track.length < 2) {
        final metadata = (await _dio.get(
                "${server.address}/library/metadata/" + track.first["ratingKey"],
                queryParameters: queryParameters))
            .data["MediaContainer"]["Metadata"][0];

        return [
          for (var e in metadata["Chapter"])
            Chapter(
              length: Duration(milliseconds: e["endTimeOffset"] - e["startTimeOffset"]),
              name: e["tag"] ?? "Chapter ${e["index"]}",
              url: _makeLink(track.first["Media"][0]["Part"][0]["key"])!,
              id: track.first["key"],
              end: Duration(milliseconds: e["endTimeOffset"]),
              start: Duration(milliseconds: e["startTimeOffset"]),
            )
        ];
      } else {
        return [
          for (var e in track)
            Chapter(
              length: Duration(milliseconds: e["duration"]),
              name: e["title"],
              url: _makeLink(e["Media"][0]["Part"][0]["key"])!,
              id: e["ratingKey"],
            )
        ];
      }
    }

    return Audiobook(
      author: album["parentTitle"] ?? "",
      authorId: album["parentRatingKey"],
      summary: album["summary"] ?? "",
      title: album["title"] ?? "",
      releaseDate: DateTime.tryParse(album["originallyAvailableAt"] ?? ""),
      thumb: _makeLink(album["thumb"]),
      chapters: await chapters(),
      userRating: album["userRating"] ?? 0.0,
      id: id,
      publisher: album["studio"],
      chapterSource: track.length < 2 ? ChapterSource.embedded : ChapterSource.files,
      // series: makeMediaList(album["Collection"])
      // .firstWhere((e) => e.type == MediaItemType.series),
    );
  }

  @override
  Future<void> reportTimelinePosition(Audiobook book,
      {required bool isPaused, required Duration position}) async {
    //! Crashes dashboard in plex web app
    //   await _dio.get("$_baseUrl/:/timeline", queryParameters: {
    //     "state": isPaused ? "paused" : "playing",
    //     "time": position.inMilliseconds,
    //     "duration": book.length.inMilliseconds,
    //     "key": "/library/metadata/${book.id}",
    //     "ratingKey": book.id,
    //   });
  }

  @override
  Future<Author> getAuthor(String id, {int start = 50, int limit = 0}) async =>
      await _dio.get("${server.address}/library/metadata/$id/children").then((v) {
        List<MediaItem> books = [];

        if (v.data["MediaContainer"]["Metadata"] != null) {
          for (var x in v.data["MediaContainer"]["Metadata"]) {
            books.add(MediaItem(
              thumb: _makeLink(x["thumb"] ?? ""),
              title: x["title"],
              id: x["ratingKey"],
              summary: x["summary"],
              title2: x["parentTitle"],
              type: MediaItemType.audioBook,
            ));
          }
        }

        return Author(
          id: id,
          books: books,
          name: v.data["MediaContainer"]["title2"],
          summary: v.data["MediaContainer"]["summary"],
          thumb: _makeLink(v.data["MediaContainer"]["thumb"] ?? "")!,
        );
      });

  /// Used for loading Client from disk
  factory PlexRepository.fromMap(Map map) => PlexRepository(
        clientId: map["clientId"],
        library: MediaItem.fromMap(map["library"]),
        server: PlexDevice.fromMap(map["server"]),
        token: map["token"],
      );

  /// Used for saving Client to disk
  @override
  Map toMap() => {
        "clientId": clientId,
        "library": library.toMap(),
        "server": server.toMap(),
        "token": token,
      };

  /// Gets servers from Plex.tv and Updates [PlexRepository.server]
  @override
  Future<void> updateServerInfo() async {
    var devices = await findServers(clientId: clientId, token: token);
    for (var server in devices) {
      if (server.clientIdentifier == server.clientIdentifier) {
        server.useRelay = !await server.ping(_dio);
      }
    }
  }

  @override
  Future<void> rateItem(String id, double rating) async {
    await _dio.put("${server.address}/:/rate", queryParameters: {
      "identifier": "com.plexapp.plugins.library",
      "key": id,
      "rating": rating * 2,
    });
  }

  @override
  Uri? transcodeImage(Uri? uri, {required int height, required int width}) {
    return uri?.replace(query: uri.query + "&height=$height&width=$width");
  }
}

extension PlexApiHelpers on PlexRepository {
  List<MediaItem> makeMediaList(Response<dynamic> res) {
    if (res.data["MediaContainer"]["Metadata"] != null) {
      return (res.data["MediaContainer"]["Metadata"] as List).map((item) {
        String title = (item["title"] as String).replaceAll("Series: ", "");

        return MediaItem(
          thumb: _makeLink(item["thumb"]),
          title: title,
          id: item["ratingKey"],
          title2: item["parentTitle"],
          type: _pickType(item)!,
          summary: item["summary"],
        );
      }).toList();
    } else if (res.data["MediaContainer"]["Directory"] != null) {
      return (res.data["MediaContainer"]["Directory"] as List).map((item) {
        return MediaItem(
          title: item["title"],
          id: item["key"],
          type: _pickType(item)!,
        );
      }).toList();
    }

    return [];
  }

  MediaItemType? _pickType(dynamic e) {
    if (e["type"] == "collection" && (e["title"] as String).startsWith("Series: ")) {
      return MediaItemType.series;
    }
    if (e["type"] == "collection") return MediaItemType.collection;
    if (e["type"] == "album") return MediaItemType.audioBook;
    if (e["type"] == "genre") return MediaItemType.genre;
  }

  Uri? _makeLink(String str) {
    var x = Uri.parse(server.address + str).replace(
      queryParameters: {
        "X-Plex-Token": _dio.options.headers["X-Plex-Token"],
        "X-Plex-Client-Identifier": _dio.options.headers["X-Plex-Client-Identifier"],
      },
    );
    return x;
  }
}
