// Whitelist of hub.context to show
import 'api.dart';
import 'classes.dart';
import 'http.dart';

abstract class HubContext {
  static const recentlyAdded = "hub.music.recent.added"; //Recently Added in Audiobooks
  static const moreByAuthor = "hub.music.recent.artist"; //More by Becky Albertalli
  static const moreInGenre = "hub.music.recent.genre"; //More in Young Adult Fiction
  static const popular = "hub.music.popular.popular"; //Most Played in June
}

Future<List<PlexHub>> getHubs() async {
  final hubs = await http.get(
    "/hubs/sections/${Plex.Account.libraryId}",
    queryParameters: const {
      "count": 10,
      "includeRecentChannels": 1,
      "includeMeta": 1,
      "includeExternalMetadata": 1,
      "excludeFields": "summary",
    },
  ).then((e) => e.data["MediaContainer"]);

  if (hubs["Hub"] == null) return [];

  List<PlexHub> items = [];

  for (var e in hubs["Hub"]) {
    switch (e["context"]) {
      case HubContext.moreByAuthor:
        items.add(PlexHub.fromMap(e));
        break;
      case HubContext.moreInGenre:
        items.add(PlexHub.fromMap(e));
        break;
      case HubContext.popular:
        items.add(PlexHub.fromMap(e));
        break;
      case HubContext.recentlyAdded:
        items.add(PlexHub.fromMap(e));
        break;
    }
  }

  return items;
}

class PlexHub {
  String hubKey;
  String key;
  String hubId;
  String context;
  String type;
  String style;
  int size;
  bool more;

  List<LibraryItem> items;

  String displayTitle;

  PlexHub({
    required this.hubKey,
    required this.key,
    required this.hubId,
    required this.context,
    required this.style,
    required this.size,
    required this.more,
    required this.items,
    required this.type,
    required String title,
  }) : displayTitle = context == HubContext.recentlyAdded ? "Recently Added" : title;

  factory PlexHub.fromMap(Map e) {
    return PlexHub(
      hubKey: e["hubKey"],
      key: e["key"],
      hubId: e["hubIdentifier"],
      context: e["context"],
      style: e["style"],
      size: e["size"],
      more: e["more"],
      items: (e["Metadata"] as List).map((e) => LibraryItem.fromMap(e)).toList(),
      title: e["title"],
      type: "album",
    );
  }
}
