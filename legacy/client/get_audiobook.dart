import 'package:plexlit/service/plex_conection.dart';
import 'package:plexlit/legacy/model/plex_audiobook.dart';
import 'package:plexlit/legacy/model/plex_chapters.dart';

Future<AudioBook> getAudioBook(Plex plex, String path) async {
// This endpoint gets collections and userRatings
  final album = await plex.dio.get(
    path.replaceFirst("/children", ""),
    queryParameters: {
      "includeChapters": "1",
      "includeReviews": "1",
      "includeCollections": "1",
      "includeGe": "1",
    },
  ).then((e) => e.data["MediaContainer"]["Metadata"][0]);

  final track = await plex.dio.get(
    "$path/children",
    queryParameters: {
      "includeChapters": "1",
      "includeReviews": "1",
      "includeCollections": "1",
    },
  ).then((e) => e.data["MediaContainer"]);

  List<PlexChapter> chapters = [];

  // Check if album has multiple files if it dose it indecates that the
  // chapters of the audiobook are store in seprete files
  if (track["Metadata"].length == 1) {
    // Get the first file in the metadata list with its
    // own api requst becose the initle requst to get the
    // album dose not contain chapters enbedid in the files
    final file = await plex.dio.get(
      "/library/metadata/" + track["Metadata"][0]["ratingKey"],
      queryParameters: {"includeChapters": 1},
    ).then(
      (e) => e.data["MediaContainer"]["Metadata"][0],
    );

    chapters = (file["Chapter"] as List)
        .map((e) => PlexChapter(
              length: e["endTimeOffset"] - e["startTimeOffset"],
              index: e["index"],
              name: "Chapter ${e["index"]}",
              url: track["Metadata"][0]["Media"][0]["Part"][0]["key"],
              end: e["endTimeOffset"],
              start: e["startTimeOffset"],
            ))
        .toList();
  } else {
    int i = 0;

    chapters = (track["Metadata"] as List).map((e) {
      i++;
      return PlexChapter(
        length: e["Media"][0]["Part"][0]["duration"],
        index: i,
        name: e["title"],
        url: e["Media"][0]["Part"][0]["key"],
      );
    }).toList();
  }
  return AudioBook(
    author: track["title1"] ?? "",
    summary: track["summary"] ?? "",
    title: track["title2"] ?? "",
    year: track["parentYear"] ?? 0,
    thumb: track["thumb"] ?? "/:/resources/artist.png",
    hasEnbededChapters: track["Metadata"].length == 1,
    chapters: chapters,
    key: int.parse(album["ratingKey"]),
    userRating: album["userRating"] ?? 0.0,
  );
}
