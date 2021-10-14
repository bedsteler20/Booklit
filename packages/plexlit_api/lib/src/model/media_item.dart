class MediaItem {
  String title;
  String? title2;
  Uri? thumb;
  String id;
  String? summary;
  MediaItemType? type;

  MediaItem({
    required this.title,
    this.title2,
    this.type,
    this.summary,
    this.thumb,
    required this.id,
  });

  Map<String, dynamic> toMap() => {
        "id": id,
        "title": title,
        "title2": title2,
        "summary": summary,
      };

  factory MediaItem.fromMap(Map map) {
    return MediaItem(
      id: map["id"],
      title: map["title"],
      summary: map["summary"],
      thumb: map["thumb"],
      title2: map["title2"],
    );
  }
}

enum MediaItemType {
  audioBook,
  collection,
  genre,
  author,
}
