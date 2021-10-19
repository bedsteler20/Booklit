import 'package:plexlit/plexlit.dart';
// Package imports:
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart' as b;
import 'package:uuid/uuid.dart';
extension AudiobookExt on Audiobook {
  AudioSource toAudioSource() {
    return ConcatenatingAudioSource(
        children: chapters
            .map((e) => ClippingAudioSource(
                child: ProgressiveAudioSource(e.url),
                end: e.end,
                start: e.start,
                tag: b.MediaItem(
                  id: const Uuid().v4(),
                  title: title,
                  album: e.name,
                )))
            .toList());
  }
}
