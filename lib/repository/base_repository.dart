import 'package:plexlit/plexlit.dart';

/// The client api implemented by various servers.
abstract class PlexlitRepository {
  final String id = "null";
  static PlexlitClientType type = PlexlitClientType.local;
  Future<List<MediaItem>> getAudiobooks({int start, int limit});
  Future<List<MediaItem>> getCollections({int start, int limit});
  Future<List<MediaItem>> getCollection(String id, {int start, int limit});
  Future<List<MediaItem>> getGenres({int start, int limit});
  Future<List<MediaItem>> getGenre(String id, {int start, int limit});
  Future<Audiobook> getAudioBook(String id);
  Future<Author> getAuthor(String id, {int start, int limit});

  /// Reports player position to server
  Future<void> reportTimelinePosition(Audiobook book,
      {required bool isPaused, required Duration position}) async {
    throw "Plexlit.reportTimelinePosition Is not Implemented";
  }

  Map toMap();

  Uri? transcodeImage(Uri? uri, {required int height, required int width}) => uri;
}

enum PlexlitClientType {
  plex,
  jellyfin,
  local,
}
