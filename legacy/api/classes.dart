import 'api.dart';
import 'audio_book.dart';
import 'http.dart';

class PlexLibrary {
  String title;
  int key;
  PlexLibrary({required this.key, required this.title});
  factory PlexLibrary.fromApi(Map json) => PlexLibrary(key: int.parse(json["key"]), title: json["title"]);
}

class Collection {
  String thumb;
  String title;
  int key;
  Collection({required this.thumb, required this.title, required this.key});
  factory Collection.fromApi(Map i) => Collection(thumb: i["thumb"], key: int.parse(i["key"]), title: i["title"]);
}

class LibraryItem {
  int ratingKey;
  String? thumb;
  String title;
  String author;
  String type;

  LibraryItem({required this.ratingKey, required this.author, required this.thumb, required this.title, this.type = "audioBook"});

  factory LibraryItem.fromAudioBook(AudioBook e) {
    return LibraryItem(
      author: e.author,
      ratingKey: e.key,
      thumb: e.thumb,
      title: e.title,
    );
  }

  factory LibraryItem.fromMap(Map map, {String type = "audioBook"}) {
    return LibraryItem(
      author: map["author"] ?? map["parentTitle"] ?? "null",
      ratingKey: int.tryParse(map["ratingKey"]) ?? map["ratingKey"],
      thumb: map["thumb"],
      title: map["title"],
      type: type,
    );
  }

  Map toMap() {
    return {
      "author": author,
      "ratingKey": ratingKey,
      "thumb": thumb,
      "title": title,
    };
  }
}

/// Holds basic info about the server
class PlexServer {
  PlexServer({required this.address, required this.name, required this.url, required this.clientId});

  final String name;
  final String url;
  final String clientId;
  final String address;

  factory PlexServer.fromApi(Map json) => PlexServer(
        address: json["connections"][0]["address"],
        url: json["connections"].last["uri"],
        clientId: json["clientIdentifier"],
        name: json["name"],
      );
}

class PlexStyle {
  final String title;
  final String key;

  PlexStyle(this.title, this.key);
}

class PlexGenera {
  final String title;
  final String fastKey;

  PlexGenera(this.title, this.fastKey);

  factory PlexGenera.fromMap(Map map) => PlexGenera(map["title"], map["fastKey"]);
}

class PlexAuthor {
  final String title;
  final String key;
  final int ratingKey;

  PlexAuthor({required this.ratingKey, required this.title, required this.key});

  factory PlexAuthor.fromMap(Map x) => PlexAuthor(
        ratingKey: int.parse(x["ratingKey"]),
        title: x["title"],
        key: x["key"],
      );

  Future<List<LibraryItem>> children() => http.get(key).then(
        (res) => [for (var e in res.data["MediaContainer"]["Metadata"]) LibraryItem.fromMap(e)],
      );
}
