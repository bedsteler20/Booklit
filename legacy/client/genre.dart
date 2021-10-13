import 'package:plexlit/helpers/media_item_extention.dart';
import 'package:plexlit/legacy/model/plex_object.dart';
import 'package:plexlit/service/service.dart';

Future<List<PlexObject>> getAllGenres(Plex plex, {int size = 10}) => plex.dio.get(
      "/library/sections/${plex.library!.key}/genre",
      queryParameters: {
        "type": 9,
        "X-Plex-Container-Size": size,
      },
    ).then((res) => [
          for (var e in res.data["MediaContainer"]["Directory"])
            PlexObject(
              title: e["title"],
              key: e["fastKey"],
              ratingKey: int.parse(e["key"]),
              icon: getGeneraIcon(e["title"]),
            )
        ]);
