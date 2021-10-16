class MediaItem {
  String title;
  String? title2;
  Uri? thumb;
  String id;
  String? summary;
  MediaItemType type;

  MediaItem({
    required this.title,
    this.title2,
    required this.type,
    this.summary,
    this.thumb,
    required this.id,
  });

  Map<String, String> toMap() => {
        "id": id,
        "title": title,
        "type": type.string,
        if (title2 != null) "title2": title2!,
        if (summary != null) "summary": summary!,
        if (thumb != null) "thumb": thumb.toString(),
      };

  factory MediaItem.fromMap(Map map) {
    return MediaItem(
        id: map["id"],
        title: map["title"],
        summary: map["summary"],
        thumb: Uri.tryParse(map["thumb"] ?? ""),
        title2: map["title2"],
        type: MediaItemType.from[map["type"] ?? "library"]);
  }
}

enum MediaItemType {
  from,
  audioBook,
  collection,
  genre,
  author,
  library,
  series,
}

extension MediaItemTypeString on MediaItemType {
  String get string {
    switch (this) {
      case MediaItemType.collection:
        return "collection";
      case MediaItemType.genre:
        return "genre";
      case MediaItemType.audioBook:
        return "audiobook";
      case MediaItemType.author:
        return "author";
      case MediaItemType.library:
        return "library";
      case MediaItemType.series:
        return "series";
      default:
        throw RangeError("enum Fruit contains no value '$name'");
    }
  }

  operator [](String key) => (name) {
        switch (name) {
          case 'collection':
            return MediaItemType.collection;
          case 'genre':
            return MediaItemType.genre;
          case 'audiobook':
            return MediaItemType.audioBook;
          case 'author':
            return MediaItemType.author;
          case 'library':
            return MediaItemType.library;
          case 'Series':
            return MediaItemType.series;
          default:
            throw RangeError("enum Fruit contains no value '$name'");
        }
      }(key);
}
