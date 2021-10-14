import 'package:plexlit_api/src/model/media_item.dart';

class Author {
  Author({
    required this.books,
    required this.name,
    required this.id,
    required this.thumb,
    this.summary,
  });
  String name;
  String id;
  String? summary;
  Uri thumb;
  List<MediaItem> books;
}
