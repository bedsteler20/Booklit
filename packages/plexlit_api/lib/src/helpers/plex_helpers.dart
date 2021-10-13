part of '../modules/plex.dart';

extension PlexApiHelpers on PlexApi {
  List<MediaItem> makeMediaList(Response<dynamic> res) {
    if (res.data["MediaContainer"]["Metadata"] != null) {
      return (res.data["MediaContainer"]["Metadata"] as List).map((item) {
        return MediaItem(
          thumb: _makeLink(item["thumb"]),
          title: item["title"],
          id: item["ratingKey"],
          title2: item["parentTitle"],
          type: _pickType(item["type"]),
          summary: item["summary"],
        );
      }).toList();
    } else if (res.data["MediaContainer"]["Directory"] != null) {
      return (res.data["MediaContainer"]["Directory"] as List).map((item) {
        return MediaItem(
          title: item["title"],
          id: item["key"],
          type: _pickType(item["type"]),
        );
      }).toList();
    }

    return [];
  }

  MediaItemType? _pickType(dynamic e) {
    if (e == "collection") return MediaItemType.collection;
    if (e == "album") return MediaItemType.audioBook;
    if (e == "genre") return MediaItemType.genre;
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
