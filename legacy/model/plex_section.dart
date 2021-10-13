// To parse this JSON data, do
//
//     final plexSection = plexSectionFromMap(jsonString);

import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';
part 'hive_intersepters/plex_section.g.dart';

@HiveType(typeId: 2)
class PlexSection {
  PlexSection({
    required this.allowSync,
    required this.art,
    required this.composite,
    required this.filters,
    required this.refreshing,
    required this.thumb,
    required this.key,
    required this.type,
    required this.title,
    required this.agent,
    required this.scanner,
    required this.language,
    required this.uuid,
    required this.updatedAt,
    required this.createdAt,
    required this.scannedAt,
    required this.content,
    required this.directory,
    required this.contentChangedAt,
    required this.hidden,
  });

  @HiveField(0)
  final String art;
  @HiveField(1)
  final String composite;
  @HiveField(2)
  final bool filters;
  @HiveField(3)
  final bool refreshing;
  @HiveField(4)
  final String thumb;
  @HiveField(5)
  final String key;
  @HiveField(6)
  final String type;
  @HiveField(7)
  final String title;
  @HiveField(8)
  final String agent;
  @HiveField(9)
  final String scanner;
  @HiveField(10)
  final String language;
  @HiveField(11)
  final String uuid;
  @HiveField(12)
  final int updatedAt;
  @HiveField(13)
  final int createdAt;
  @HiveField(14)
  final int scannedAt;
  @HiveField(15)
  final bool content;
  @HiveField(16)
  final bool directory;
  @HiveField(17)
  final int contentChangedAt;
  @HiveField(18)
  final int hidden;
  @HiveField(19)
  final bool allowSync;

  factory PlexSection.fromJson(String str) => PlexSection.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory PlexSection.fromMap(Map<String, dynamic> json) => PlexSection(
        allowSync: json["allowSync"],
        art: json["art"],
        composite: json["composite"],
        filters: json["filters"],
        refreshing: json["refreshing"],
        thumb: json["thumb"],
        key: json["key"],
        type: json["type"],
        title: json["title"],
        agent: json["agent"],
        scanner: json["scanner"],
        language: json["language"],
        uuid: json["uuid"],
        updatedAt: json["updatedAt"],
        createdAt: json["createdAt"],
        scannedAt: json["scannedAt"],
        content: json["content"],
        directory: json["directory"],
        contentChangedAt: json["contentChangedAt"],
        hidden: json["hidden"],
      );

  Map<String, dynamic> toMap() => {
        "allowSync": allowSync,
        "art": art,
        "composite": composite,
        "filters": filters,
        "refreshing": refreshing,
        "thumb": thumb,
        "key": key,
        "type": type,
        "title": title,
        "agent": agent,
        "scanner": scanner,
        "language": language,
        "uuid": uuid,
        "updatedAt": updatedAt,
        "createdAt": createdAt,
        "scannedAt": scannedAt,
        "content": content,
        "directory": directory,
        "contentChangedAt": contentChangedAt,
        "hidden": hidden,
      };
}
