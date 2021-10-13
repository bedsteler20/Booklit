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
}

enum MediaItemType { audioBook, collection, genre }
