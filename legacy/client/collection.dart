import 'package:plexlit/legacy/model/plex_object.dart';
import 'package:plexlit/service/service.dart';

Future<List<PlexObject>> getAllCollections(Plex plex, {int size = 10}) => plex.dio.get(
      "/library/sections/${plex.library!.key}/collections",
      queryParameters: {
        "includeCollections": 1,
        "X-Plex-Container-Size": size,
      },
    ).then((res) => [
          for (var e in res.data["MediaContainer"]["Metadata"])
            PlexObject(
              ratingKey: int.parse(e["ratingKey"]),
              title: e["title"],
              key: e["key"],
              subtitle: e["parentTitle"],
              thumb: e["thumb"],
            )
        ]);
