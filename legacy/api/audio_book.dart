import 'http.dart';

import 'chapters.dart';

class AudioBook {
  int key;

  double userRating;

  String title;

  int year;

  String thumb;

  String summary;

  String author;

  bool hasEnbededChapters;

  //File used as base if it has enbeded chapter
  // Also used as fallback for multipart files

  String mainFile;

  List<ChapterFile>? chapterFiles;

  List<EmbededChapter>? embededChaptors;

  AudioBook({
    required this.userRating,
    required this.key,
    required this.title,
    required this.year,
    required this.author,
    required this.summary,
    required this.thumb,
    required this.hasEnbededChapters,
    required this.mainFile,
    this.chapterFiles,
    this.embededChaptors,
  });

  Map toMap() {
    return {
      "title": title,
      "key": key,
      "mainFile": mainFile,
      "hasEnbededChapters": hasEnbededChapters,
      "author": author,
      "thumb": thumb,
      "year": year,
      "summary": summary,
      "userRating": userRating,
      "embededChaptors": embededChaptors!.map((e) => e.toMap()).toList(),
      "chapterFiles": chapterFiles!.map((e) => e.toMap()).toList()
    };
  }

  factory AudioBook.fromMap(Map json) {
    return AudioBook(
      author: json["author"],
      hasEnbededChapters: json["hasEnbededChapters"],
      key: int.parse(json["key"]),
      mainFile: json["mainFile"],
      summary: json["summery"],
      thumb: json["thumb"],
      title: json["title"],
      year: int.parse(json["year"]),
      userRating: double.parse(json["userRating"]),
      embededChaptors: json["embededChaptors"].map((e) => EmbededChapter.fromMap(e)).toList(),
      chapterFiles: json["chapterFiles"].map((e) => ChapterFile.fromMap(e)).toList(),
    );
  }

  static Future<AudioBook> get(int ratingKey) async {
// This endpoint gets collections and userRatings
    final album = await http.get(
      "/library/metadata/$ratingKey",
      queryParameters: {
        "includeChapters": "1",
        "includeReviews": "1",
        "includeCollections": "1",
      },
    ).then((e) => e.data["MediaContainer"]["Metadata"][0]);

    final track = await http.get(
      "/library/metadata/$ratingKey/children",
      queryParameters: {
        "includeChapters": "1",
        "includeReviews": "1",
        "includeCollections": "1",
      },
    ).then((e) => e.data["MediaContainer"]);

    List<EmbededChapter>? embededChaptors;
    List<ChapterFile>? chapterFiles;

// Check if album has multiple files if it dose it indecates that the
    // chapters of the audiobook are store in seprete files
    if (track["Metadata"].length < 1) {
      embededChaptors = [];

      // Get the first file in the metadata list with its
      // own api requst becose the initle requst to get the
      // album dose not contain chapters enbedid in the files
      final fileRes = await http.get("/library/metadata/" + track["Metadata"][0]["ratingKey"]).then(
            (e) => e.data["MediaContainer"]["Metadata"][0],
          );
      final file = fileRes.data["MediaContainer"]["Metadata"][0];

      // Creates Enbeded Chapters
      for (var chapter in file["Chapter"]) {
        embededChaptors.add(EmbededChapter(
          end: Duration(milliseconds: chapter["endTimeOffset"]),
          start: Duration(milliseconds: chapter["startTimeOffset"]),
          index: chapter["index"],
        ));
      }

      // Get the chapter files
    } else {
      chapterFiles = [];
      int i = 0;
      for (var fileData in track["Metadata"]) {
        chapterFiles.add(ChapterFile(
            name: fileData["title"],
            url: fileData["Media"][0]["Part"][0]["key"],
            length: Duration(milliseconds: fileData["Media"][0]["Part"][0]["duration"]),
            index: i));
        i++;
      }
    }

    return AudioBook(
      author: track["title1"] ?? "",
      summary: track["summary"] ?? "",
      title: track["title2"] ?? "",
      year: track["parentYear"] ?? 0,
      thumb: track["thumb"] ?? "/:/resources/artist.png",
      mainFile: track["Metadata"][0]["Media"][0]["Part"][0]["key"] ?? "",
      hasEnbededChapters: track["Metadata"].length == 1,
      chapterFiles: chapterFiles,
      embededChaptors: embededChaptors,
      key: ratingKey,
      userRating: album["userRating"] ?? 0.0,
    );
  }
}
