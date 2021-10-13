import 'package:hive_flutter/hive_flutter.dart';

import 'plex_chapters.dart';

part 'plex_audiobook.g.dart';

@HiveType(typeId: 5)
class AudioBook {
  @HiveField(0)
  double userRating;

  @HiveField(1)
  String title;

  @HiveField(2)
  int year;

  @HiveField(3)
  String thumb;

  @HiveField(4)
  String summary;

  @HiveField(5)
  String author;

  @HiveField(6)
  bool hasEnbededChapters;
  @HiveField(7)
  int key;

  @HiveField(8)
  List<PlexChapter> chapters;

  AudioBook({
    required this.userRating,
    required this.key,
    required this.title,
    required this.year,
    required this.author,
    required this.summary,
    required this.thumb,
    required this.hasEnbededChapters,
    required this.chapters,
  });

  // Map toMap() {
  //   return {
  //     "title": title,
  //     "key": key,
  //     "author": author,
  //     "thumb": thumb,
  //     "year": year,
  //     "summary": summary,
  //     "userRating": userRating,
  //     "chapters": chapters.map((e) => e.toMap()),
  //     "hasEnbededChapters": hasEnbededChapters,
  //   };
  // }

  // factory AudioBook.fromMap(Map json) {
  //   return AudioBook(
  //     author: json["author"],
  //     hasEnbededChapters: json["hasEnbededChapters"],
  //     key: int.parse(json["key"]),
  //     summary: json["summery"],
  //     thumb: json["thumb"],
  //     title: json["title"],
  //     year: int.parse(json["year"]),
  //     userRating: double.parse(json["userRating"]),
  //     chapters: json["chapters"].map((e) => PlexChapter.fromMap(e)).toList(),
  //   );
  // }

}
