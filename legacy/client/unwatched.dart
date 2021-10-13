import 'package:plexlit/legacy/model/plex_object.dart';
import 'package:plexlit/service/plex_conection.dart';

Future<List<PlexObject>> unWatched(Plex plex, {int size = 10}) => plex.dio.get(
      "/library/sections/${plex.library!.key}/all",
      queryParameters: {
        "type": 9,
        "unwatched": 1,
        "X-Plex-Container-Size": size,
      },
    ).then((res) => [
          for (var e in res.data["MediaContainer"]["Metadata"])
            PlexObject(
              title: e["title"],
              key: e["key"],
              ratingKey: int.parse(e["ratingKey"]),
              subtitle: e["parentTitle"],
              thumb: e["thumb"],
            )
        ].getRange(0, 14).toList());
