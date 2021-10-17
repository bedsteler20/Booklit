import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:plexlit/model/model.dart';

import '../repository.dart';

part 'helpers.dart';

class PlexApi extends PlexlitRepository {
  String token;
  PlexDevice server;
  String clientId;
  MediaItem library;

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
          "X-Plex-Device": Platform.operatingSystem,
          "X-Plex-Device-Name": Platform.localHostname,
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

  PlexApi({
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
        "X-Plex-Device": Platform.operatingSystem,
        "X-Plex-Device-Name": Platform.localHostname,
        "X-Plex-Sync-Version": "2",
        "X-Plex-Features": "external-media%2Cindirect-media",
        "accept": "application/json",
      },
    );
  }

  @override
  get getAudiobooks => ({int start = 0, int limit = 50}) async => _dio.get(
        "$libraryAddress/all?type=9",
        queryParameters: {
          "X-Plex-Container-Start": start,
          "X-Plex-Container-Size": limit,
        },
      ).then((_) => makeMediaList(_));

  @override
  get getCollections => ({int start = 0, int limit = 50}) async => _dio.get(
        "$libraryAddress/collections",
        queryParameters: {
          "X-Plex-Container-Start": start,
          "X-Plex-Container-Size": limit,
        },
      ).then(makeMediaList);
  @override
  get getCollection => (String id, {int start = 0, int limit = 50}) async => _dio.get(
        "${server.address}/library/collections/$id/children",
        queryParameters: {
          "type": 9,
          "X-Plex-Container-Start": start,
          "X-Plex-Container-Size": limit,
        },
      ).then(makeMediaList);
  @override
  get getGenres => ({int start = 0, int limit = 50}) async => _dio.get(
        "$libraryAddress/genre",
        queryParameters: {
          "type": 9,
          "X-Plex-Container-Start": start,
          "X-Plex-Container-Size": limit,
        },
      ).then(makeMediaList);
  @override
  get getGenre => (String id, {int start = 0, int limit = 50}) async => _dio.get(
        "$libraryAddress/all",
        queryParameters: {
          "type": 9,
          "genre": id,
          "X-Plex-Container-Start": start,
          "X-Plex-Container-Size": limit,
        },
      ).then(makeMediaList);

  @override
  get getAudioBook => (String id) async {
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
          // series: makeMediaList(album["Collection"])
          // .firstWhere((e) => e.type == MediaItemType.series),
        );
      };

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
  factory PlexApi.fromMap(Map map) => PlexApi(
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

  /// Gets servers from Plex.tv and Updates [PlexApi.server]
  Future<void> updateServerInfo() async {
    print("Updating PMS Info");
    var devices = await findServers(clientId: clientId, token: token);
    for (var i in devices) {
      if (i.clientIdentifier == server.clientIdentifier) server = i;
    }
  }

  @override
  Uri? transcodeImage(Uri? uri, {required int height, required int width}) {
    return uri?.replace(query: uri.query + "&height=$height&width=$width");
  }
}
