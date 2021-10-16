part of 'plex.dart';

extension PlexApiHelpers on PlexApi {
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
