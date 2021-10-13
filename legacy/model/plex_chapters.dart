import 'package:hive_flutter/hive_flutter.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:plexlit/client/helpers.dart';
import 'package:plexlit/service/plex_conection.dart';
import 'package:plexlit/legacy/model/plex_audiobook.dart';

part 'hive_intersepters/plex_chapters.g.dart';

@HiveType(typeId: 4)
class PlexChapter {
  PlexChapter({
    this.start,
    this.end,
    required this.length,
    required this.index,
    required this.name,
    required this.url,
  });
  @HiveField(0)
  int? start;

  @HiveField(1)
  int? end;

  @HiveField(2)
  int index;

  @HiveField(3)
  String name;

  @HiveField(4)
  String url;

  @HiveField(5)
  int length;

  AudioSource toAudioSource(Plex connection, AudioBook book) {
    if (start == null || end == null) {
      return ProgressiveAudioSource(
        makePlexUri(url, connection),
        tag: MediaItem(
          id: index.toString(),
          album: name,
          title: book.title,
          artUri: makePlexUri(book.thumb, connection),
        ),
      );
    } else {
      return ClippingAudioSource(
        child: ProgressiveAudioSource(makePlexUri(url, connection)),
        end: Duration(milliseconds: end!),
        start: Duration(milliseconds: start!),
        tag: MediaItem(
          id: index.toString(),
          album: name,
          title: book.title,
          artUri: makePlexUri(book.thumb, connection),
        ),
      );
    }
  }
}
