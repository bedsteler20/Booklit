// Dart imports:
import 'dart:async';

// Package imports:
import 'package:just_audio/just_audio.dart';
import 'package:miniplayer/miniplayer.dart';

// Project imports:
import 'package:plexlit/plexlit.dart';

class AudioProvider extends ChangeNotifierState with AutoRewind {
  late final BuildContext context;
  static final _audio = AudioPlayer();

  PlayerState playerState = PlayerState(false, ProcessingState.buffering);
  Duration position = const Duration(milliseconds: 0);
  Duration bufferedPosition = const Duration(milliseconds: 0);
  int chapterIndex = 0;
  double speed = 1;
  bool skipSilence = false;
  Audiobook? current;
  bool autoRewindEnabled = true;

  Chapter? get chapter => current?.chapters[chapterIndex];
  Duration get duration => chapter!.length;

  Future<void> play() async {
    if (autoRewindEnabled && autoRewindSeconds > 2) {
      await seek(Duration(seconds: position.inSeconds - autoRewindSeconds));
      stopAutoRemindTimer();
    }
    await _audio.play();
  }

  Future<void> pause() async {
    if (autoRewindEnabled) startAutoRemindTimer();
    await _audio.pause();
  }

  Future<void> setSkipSilence(bool b) => _audio.setSkipSilenceEnabled(b);
  void setAutoRewindEnabled(bool b) => setState(() => autoRewindEnabled = b);

  Future<void> setSpeed(double speed) => _audio.setSpeed(speed);

  Future<void> seek(Duration? position, {int? chapterIndex}) async {
    if (chapterIndex != null) {
      this.chapterIndex = chapterIndex;
      notifyListeners();
    }
    _audio.seek(position, index: chapterIndex);
  }

  Future<void> load(Audiobook? book) async {
    if (book == null) throw "Cant play audio book if it is null";
    current = book;
    saveState();

    await _audio.setAudioSource(
      book.toAudioSource(),
      preload: true,
      initialIndex: STORAGE.progress.get(book.id)?["index"],
      initialPosition: Duration(milliseconds: STORAGE.progress.get(book.id)?["position"] ?? 0),
    );
  }

  void stop() async {
    current = null;
    notifyListeners();
    saveState();
  }

  @override
  Future<AudioProvider> initState() async {
    super.initState();

    _audio.currentIndexStream.listen((e) => setState(() => chapterIndex = e ?? 0));
    _audio.bufferedPositionStream.listen((e) => setState(() => bufferedPosition = e));
    _audio.playerStateStream.listen((e) => setState(() => playerState = e));
    _audio.speedStream.listen((e) => setState(() => speed = e));
    _audio.skipSilenceEnabledStream.listen((e) => setState(() => skipSilence = e));
    _audio.positionStream.listen((e) => setState(() => position = e));

    // Position Tracking
    _audio.positionStream
        .timeout(const Duration(seconds: 5))
        .listen((e) => STORAGE.progress.put(current?.id ?? "null", {
              "position": _audio.position.inMilliseconds,
              "index": _audio.currentIndex,
            }));

    return this;
  }

  @override
  Future<void> dispose() async {
    super.dispose();
    _audio.dispose();
  }

  @override
  Future<void> loadState() async {
    if (STORAGE.state.containsKey("playerState")) {
      load(Audiobook.fromMap(await STORAGE.state.get("playerState")));
    }
  }

  @override
  Future<void> saveState() async {
    STORAGE.state.put("playerState", current?.toMap());
  }
}
