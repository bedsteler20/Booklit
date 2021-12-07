// Package imports:
import 'package:just_audio/just_audio.dart';

// Project imports:
import 'package:booklit/booklit.dart';

extension AudiobookExt on Audiobook {
  AudioSource toAudioSource() {
    return ConcatenatingAudioSource(
        children: chapters
            .map((e) => ClippingAudioSource(
                  child: ProgressiveAudioSource(e.url),
                  end: e.end,
                  start: e.start,

                  /// JustAudio Background is broken
                  // tag: b.MediaItem(
                  //   id: Uuid.v4(),
                  //   title: title,
                  //   album: e.name,
                  //   artUri: thumb,
                  // ),
                ))
            .toList());
  }
}
