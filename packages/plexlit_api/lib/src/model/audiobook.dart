class Audiobook {
  Audiobook({
    required this.title,
    required this.author,
    required this.id,
    required this.chapters,
    this.thumb,
    this.summary,
    this.releaseDate,
    this.userRating = 0,
    this.viewCount,
  }) : length = Duration(milliseconds: chapters.fold(0, (p, e) => p += e.length.inMilliseconds));

  String title;
  String author;
  String id;
  Uri? thumb;
  String? summary;
  DateTime? releaseDate;
  double userRating;
  int? viewCount;
  List<Chapter> chapters;
  Duration length;
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
}
