// Dart imports:
import 'dart:async';

// Package imports:
import 'package:just_audio/just_audio.dart';

// Project imports:
import 'package:plexlit/plexlit.dart';

class AudioProvider extends ChangeNotifierState {
  static final _audio = AudioPlayer();

  Duration? sleepTimerDuration;
  Duration? _sleepEndTime; //The exect position in playback to stop
  bool stopAtEndOfChapter = false;

  /// value that represents the currently playing audiobook
  Audiobook? current;

  Chapter? chapter;

  PlayerState playerState = PlayerState(false, ProcessingState.buffering);

  double speed = 1;

  /// Only on Android
  bool skipSilence = false;

  /// The duration of the current audio or null if unknown.
  Duration get duration => chapter!.length;

  /// The current position of the player.
  Duration position = const Duration(milliseconds: 0);

  /// The position up to which buffered audio is available.
  Duration bufferedPosition = const Duration(milliseconds: 0);

  late final BuildContext context;

  Future<void> play() => _audio.play();

  Future<void> pause() => _audio.pause();

  Future<void> setSkipSilence(bool b) => _audio.setSkipSilenceEnabled(b);

  Future<void> setSpeed(double speed) => _audio.setSpeed(speed);

  Future<void> seek(Duration? position, {int? chapterIndex}) async {
    _audio.seek(position, index: chapterIndex);
  }

  void startSleepTimer({Duration? duration, bool endOfChapter = false}) {
    if (duration != null) {
      sleepTimerDuration = duration;
    } else if (endOfChapter) {
      stopAtEndOfChapter = true;
    }
  }

  Future<void> load(Audiobook? book) async {
    if (book == null) throw "Cant play audio book if it is null";
    chapter = book.chapters[0];
    current = book;

    await _audio.setAudioSource(
      book.toAudioSource(),
      preload: true,
      initialIndex: storage.progress.get(book.id)?["index"],
      initialPosition: Duration(milliseconds: storage.progress.get(book.id)?["position"] ?? 0),
    );
  }

  Future<AudioProvider> init() async {
    _audio.currentIndexStream.listen(
      (e) => setValue(() => chapter = current?.chapters[e ?? 0]),
    );
    // _audio.durationStream.listen(
    //   (e) => setValue(() => duration = e ?? const Duration()),
    // );
    _audio.bufferedPositionStream.listen(
      (e) => setValue(() => bufferedPosition = e),
    );
    _audio.playerStateStream.listen(
      (e) => setValue(() => playerState = e),
    );
    _audio.speedStream.listen(
      (e) => setValue(() => speed = e),
    );
    _audio.skipSilenceEnabledStream.listen((e) => setValue(() => skipSilence = e));
    _audio.positionStream.listen((e) => setValue(() {
          position = e;
          if (_sleepEndTime?.inSeconds == e.inSeconds) pause();
          notifyListeners();
        }));
    _audio.currentIndexStream.listen((_) {
      if (stopAtEndOfChapter) pause();
    });

    // Position Tracking
    _audio.positionStream
        .timeout(const Duration(seconds: 5))
        .listen((e) => storage.progress.put(current?.id ?? "null", {
              "position": _audio.position.inMilliseconds,
              "index": _audio.currentIndex,
            }));

    return this;
  }

  Future<void> dispose() async {
    _audio.dispose();
  }
}
