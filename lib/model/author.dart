// Package imports:

import 'media_item.dart';

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
