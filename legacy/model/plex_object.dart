import 'package:flutter/material.dart';
import 'package:plexlit/helpers/media_item_extention.dart';

///Holds bascic info on a item
class PlexObject {
  final String? key;
  final String? title;
  final String? subtitle;
  final String? thumb;
  final IconData? icon;
  final int? ratingKey;

  PlexObject({
    this.key,
    this.title,
    this.subtitle,
    this.thumb,
    this.icon,
    this.ratingKey,
  });

  static List<PlexObject> fromAlbumListJSON(dynamic v) {
    var a = v["MediaContainer"]["Metadata"] ?? v["Metadata"] ?? v;
    return [
      for (var e in a)
        PlexObject(
          title: e["title"],
          key: e["key"],
          ratingKey: int.parse(e["ratingKey"]),
          subtitle: e["parentTitle"],
          thumb: e["thumb"],
        )
    ];
  }

  static List<PlexObject> fromDictionaryListJSON(dynamic v) {
    var a = v["MediaContainer"]["Directory"] ?? v["Directory"] ?? v;
    return [
      for (var e in a)
        PlexObject(
          title: e["title"],
          key: e["fastKey"],
          ratingKey: int.parse(e["key"]),
          icon: getGeneraIcon(e["title"]),
        )
    ];
  }
}
