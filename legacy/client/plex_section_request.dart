import 'package:plexlit/helpers/media_item_extention.dart';
import 'package:plexlit/legacy/model/plex_device.dart';
import 'package:plexlit/legacy/model/plex_object.dart';
import 'package:plexlit/legacy/model/plex_section.dart';
import 'package:plexlit/service/service.dart';

extension PlexSectionRequsts on PlexSection {
  Future<List<PlexObject>> genras({int size = 10}) =>
      Plex.to.dio.get("/library/sections/$key/genre", queryParameters: {
        "type": 9,
        "X-Plex-Container-Size": size
      }).then((res) => PlexObject.fromDictionaryListJSON(res.data));

  Future<List<PlexObject>> collections({int size = 10}) =>
      Plex.to.dio.get("/library/sections/$key/collections", queryParameters: {
        "includeCollections": 1,
        "X-Plex-Container-Size": size
      }).then((res) => PlexObject.fromAlbumListJSON(res.data));

  Future<List<PlexObject>> unRead({int size = 10}) =>
      Plex.to.dio.get("/library/sections/$key/all", queryParameters: {
        "type": 9,
        "unwatched": 1,
        "X-Plex-Container-Size": size
      }).then((res) => PlexObject.fromAlbumListJSON(res.data));

  Future<List<PlexObject>> read({int size = 10}) => Plex.to.dio.get(
        "/library/sections/$key/all",
        queryParameters: {"type": 9, "unwatched": 0, "X-Plex-Container-Size": size},
      ).then((res) => PlexObject.fromAlbumListJSON(res.data));
}
