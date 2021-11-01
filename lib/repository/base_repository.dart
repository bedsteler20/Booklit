// Package imports:
import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:dio_cache_interceptor_hive_store/dio_cache_interceptor_hive_store.dart';

// Project imports:
import 'package:booklit/booklit.dart';

/// The client api implemented by various servers.
abstract class PlexlitRepository {
  String clientId = "null";
  String title = "null";
  String? title2;

  final client = Dio()
    ..interceptors.add(DioCacheInterceptor(options: CacheOptions(store: HiveCacheStore(null))));

  final RepoFeatures features = const RepoFeatures();

  static PlexlitClientType type = PlexlitClientType.local;
  Future<List<MediaItem>> getAudiobooks({int start = 0, int limit = 0}) =>
      throw UnimplementedError();
  Future<List<MediaItem>> getCollections({int start = 0, int limit = 0}) =>
      throw UnimplementedError();
  Future<List<MediaItem>> getCollection(String id, {int start = 0, int limit = 0}) =>
      throw UnimplementedError();
  Future<List<MediaItem>> getGenres({int start = 0, int limit = 0}) => throw UnimplementedError();
  Future<List<MediaItem>> getGenre(String id, {int start = 0, int limit = 0}) =>
      throw UnimplementedError();
  Future<Audiobook> getAudioBook(String id) => throw UnimplementedError();
  Future<Author> getAuthor(String id, {int start = 0, int limit = 0}) => throw UnimplementedError();

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

class RepoFeatures {
  /// If the repo can provide a list of all collections
  final bool allCollections;

  /// If the repo supports collections
  final bool collections;

  /// Suport for geting recently added books
  final bool newBooks;

  /// Suport List genres
  final bool allGenres;

  /// Suport for genres
  final bool genres;

  const RepoFeatures({
    this.allCollections = false,
    this.collections = false,
    this.genres = false,
    this.allGenres = false,
    this.newBooks = false,
  });
}

enum PlexlitClientType {
  plex,
  jellyfin,
  local,
}
