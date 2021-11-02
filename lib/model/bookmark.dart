// Package imports:
import 'package:uuid/uuid.dart';

class Bookmark {
  Duration position;
  String id;
  String? message;
  int chapterNumber;

  Bookmark({this.message, required this.position, required this.chapterNumber})
      : id = const Uuid().v4();

  Map toMap() => {
        "position": position.inSeconds,
        "id": id,
        "message": message,
        "chapterNumber": chapterNumber 
      };

  Bookmark.fromMap(Map map)
      : id = map["id"],
        message = map["message"],
        position = Duration(seconds: map["position"]),
        chapterNumber = map["chapterNumber"] ?? 0;
}
