// Project imports:
import 'package:plexlit/plexlit.dart';

/// The client api implemented by various servers.
abstract class PlexlitRepository {
  String clientId = "null";
  String title = "null";
  String? title2;

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

  Future<void> updateServerInfo() async => this;

  Future<void> rateItem(String id, double rating) => throw UnimplementedError();

  Map toMap();

  Uri? transcodeImage(Uri? uri, {required int height, required int width}) => uri;
}

enum PlexlitClientType {
  plex,
  jellyfin,
  local,
}
