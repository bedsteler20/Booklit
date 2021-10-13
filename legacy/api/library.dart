import 'api.dart';
import 'classes.dart';
import 'http.dart';

class Library {
  Future<List<PlexAuthor>> authors({int size = 10000, String sort = "lastViewedAt"}) {
    return http.get(
      "${Plex.Account.library}/all",
      queryParameters: {
        "type": 8,
        "X-Plex-Container-Size": size,
        "sort": sort,
      },
    ).then(
      (res) => [for (var e in res.data["MediaContainer"]["Metadata"]) PlexAuthor.fromMap(e)],
    );
  }

  Future<List<PlexGenera>> genres() {
    return http.get("${Plex.Account.library}/genre", queryParameters: {"type": 9}).then(
      (res) => [for (var e in res.data["MediaContainer"]["Directory"]) PlexGenera.fromMap(e)],
    );
  }

  /// Returns all collections
  Future<List<LibraryItem>> collections({int size = 10}) => http.get(
        "${Plex.Account.library}/collections",
        queryParameters: {
          "includeCollections": 1,
          "X-Plex-Container-Size": size,
        },
      ).then((res) => [
            for (var e in res.data["MediaContainer"]["Metadata"]) LibraryItem.fromMap(e, type: "collection"),
          ]);

  Future<List<LibraryItem>> recentlyAdded({int size = 10}) {
    return http.get(
      "${Plex.Account.library}/recentlyAdded",
      queryParameters: {
        "type": 9,
        "viewCount>": 1,
        "sort": "lastViewedAt:desc",
        "excludeFields": "summary",
        "X-Plex-Container-Size": size,
      },
    ).then((res) => _phraseMeta(res.data));
  }

  List<LibraryItem> _phraseMeta(dynamic data, {String type = "audioBook"}) {
    try {
      return [for (var e in data["MediaContainer"]["Metadata"]) LibraryItem.fromMap(e, type: type)];
    } catch (e) {
      return [];
    }
  }
}
