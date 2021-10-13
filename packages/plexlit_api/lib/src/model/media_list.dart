import 'media_item.dart';

class MediaList<T> {
  List<T> children;
  String title;

  MediaList({required this.children, this.title = "Null"});

  static MediaList<MediaItem> fromPlexMediaContainer({required String title, required dynamic children}) {
    List<MediaItem> _children = [];

    for (var item in children["MediaContainer"]["Metadata"]) {
      children.add(MediaItem(
        thumb: item["thumb"],
        title: item["title"],
        id: item["ratingKey"],
        title2: item["parentTitle"],
      ));
    }
    return MediaList<MediaItem>(
      children: children,
      title: title,
    );
  }
}
