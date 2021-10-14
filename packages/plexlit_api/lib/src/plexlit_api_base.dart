import 'dart:io';

import 'package:dio/dio.dart';
import 'package:plexlit_api/plexlit_api.dart';
import 'package:plexlit_api/src/model/author.dart';
import 'package:plexlit_api/src/model/plex/plex_media_server.dart';

/// Creates Api Clients
class PlexlitConnection {}

/// The client api implemented by various servers.
abstract class PlexlitApiClient {
  external static PlexlitClientType type;
  external final Future<List<MediaItem>> Function({int start, int limit}) getAudiobooks;
  external final Future<List<MediaItem>> Function({int start, int limit}) getCollections;
  external final Future<List<MediaItem>> Function(String id, {int start, int limit}) getCollection;
  external final Future<List<MediaItem>> Function({int start, int limit}) getGenres;
  external final Future<List<MediaItem>> Function(String id, {int start, int limit}) getGenre;
  external final Future<Audiobook> Function(String id) getAudioBook;
  Future<Author> getAuthor(String id, {int start, int limit});

  /// Reports player position to server
  Future<void> reportTimelinePosition(Audiobook book,
      {required bool isPaused, required Duration position}) async {
    throw "Plexlit.reportTimelinePosition Is not Implemented";
  }

  external Map toMap();
}

enum PlexlitClientType {
  plex,
  jellyfin,
  local,
}
