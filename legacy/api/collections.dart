import 'api.dart';
import 'classes.dart';
import 'http.dart';

class CollectionMethods {
  Future<List<Collection>> getAll() async {
    return http.get(
      "${Plex.Account.library}/collections",
      queryParameters: {
        "includeCollections": 1,
        "includeExternalMedia": 1,
        "includeAdvanced": 1,
        "includeMeta": 1,
      },
    ).then((res) {
      List<Collection> i = [];
      for (var x in res.data["MediaContainer"]["Metadata"]) {
        i.add(Collection.fromApi(x));
      }
      return i;
    });
  }

  Future<List<LibraryItem>> get(int ratingKey) async {
    return http.get(
      "${Plex.Account.library}/collections/$ratingKey/children",
      queryParameters: {"excludeAllLeaves": 1},
    ).then((res) {
      List<LibraryItem> i = [];
      for (var x in res.data["MediaContainer"]["Metadata"]) {
        i.add(LibraryItem(
          ratingKey: int.parse(x["ratingKey"]),
          author: x["parentTitle"],
          thumb: x["thumb"] ?? "/:/resources/artist.png",
          title: x["title"],
        ));
      }
      return i;
    });
  }
}
