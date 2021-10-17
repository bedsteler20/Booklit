// Project imports:
import 'media_item.dart';

class Audiobook {
  Audiobook({
    required this.title,
    required this.author,
    required this.id,
    required this.chapters,
    required this.authorId,
    required this.chapterSource,
    this.thumb,
    this.summary,
    this.releaseDate,
    this.userRating = 0,
    this.viewCount,
    this.publisher,
    this.series,
    
  }) : length = Duration(milliseconds: chapters.fold(0, (p, e) => p += e.length.inMilliseconds));

  String title;
  String author;
  String id;
  String authorId;
  Uri? thumb;
  String? summary;
  String? publisher;
  DateTime? releaseDate;
  double userRating;
  int? viewCount;
  List<Chapter> chapters;
  Duration length;
  MediaItem? series;
  ChapterSource chapterSource;

  Map toMap() => {
        "title": title,
        "authorId": authorId,
        "author": author,
        "thumb": thumb.toString(),
        "summary": summary,
        "userRating": userRating,
        "viewCount": viewCount,
        "releaseDate": releaseDate?.toIso8601String(),
        "length": length,
        "chapters": chapters.map((e) => e.toMap()).toList(),
        "publisher": publisher,
        "chapterSource": chapterSource.index,
      };

  factory Audiobook.fromMap(Map map) => Audiobook(
        title: map["title"],
        author: map["author"],
        id: map["id"],
        chapters: (map["chapters"] as List).map((e) => Chapter.fromMap(e)).toList(),
        authorId: map["authorId"],
        releaseDate: DateTime.tryParse(map["releaseDate"]),
        summary: map["summary"],
        thumb: Uri.tryParse(map["thumb"]),
        userRating: map["userRating"],
        viewCount: map["viewCount"],
        publisher: map["publisher"],
        chapterSource: ChapterSource.values[map["chapterSource"]],
      );
}

class Chapter {
  Chapter({
    required this.name,
    required this.url,
    required this.length,
    required this.id,
    this.start,
    this.end,
  });
  String id;
  String name;
  Uri url;
  Duration? start;
  Duration? end;
  Duration length;

  Map toMap() => {
        "id": id,
        "name": name,
        "start": start?.inMilliseconds,
        "end": end?.inMilliseconds,
        "length": length.inMilliseconds,
        "url": url.toString(),
      };

  factory Chapter.fromMap(Map map) => Chapter(
        id: map["id"],
        length: Duration(milliseconds: map["length"]),
        name: map["name"],
        url: Uri.parse(map["url"]),
        end: map["end"] == null ? null : Duration(milliseconds: map["end"]),
        start: map["start"] == null ? null : Duration(milliseconds: map["start"]),
      );
}


enum ChapterSource {
  embedded, files, none, from
}
