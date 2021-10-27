// Dart imports:
// ignore_for_file: non_constant_identifier_names

import 'dart:async';

// Package imports:
import 'package:just_audio/just_audio.dart';
import 'package:miniplayer/miniplayer.dart';

// Project imports:
import 'package:plexlit/plexlit.dart';

final JustAudio = AudioPlayer();

class AudioProvider extends ChangeNotifierState with AutoRewind, SleepTimer {
  late final BuildContext context;

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
    await JustAudio.play();
  }

  Future<void> pause() async {
    if (autoRewindEnabled) startAutoRemindTimer();
    await JustAudio.pause();
  }

  Future<void> setSkipSilence(bool b) => JustAudio.setSkipSilenceEnabled(b);
  void setAutoRewindEnabled(bool b) => setState(() => autoRewindEnabled = b);

  Future<void> setSpeed(double speed) => JustAudio.setSpeed(speed);

  Future<void> seek(Duration? position, {int? chapterIndex}) async {
    if (chapterIndex != null) {
      this.chapterIndex = chapterIndex;
      notifyListeners();
    }
    JustAudio.seek(position, index: chapterIndex);
  }

  Future<void> load(Audiobook? book) async {
    if (book == null) throw "Cant play audio book if it is null";
    current = book;
    saveState();

    await JustAudio.setAudioSource(
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
  void startSleepTimer(SleepTimerType type) => setState(() => super.startSleepTimer(type));

  @override
  void stopSleepTimer() => setState(() => super.stopSleepTimer());

  @override
  Future<AudioProvider> initState() async {
    super.initState();

    JustAudio.currentIndexStream.listen((e) => setState(() => chapterIndex = e ?? 0));
    JustAudio.bufferedPositionStream.listen((e) => setState(() => bufferedPosition = e));
    JustAudio.playerStateStream.listen((e) => setState(() => playerState = e));
    JustAudio.speedStream.listen((e) => setState(() => speed = e));
    JustAudio.skipSilenceEnabledStream.listen((e) => setState(() => skipSilence = e));
    JustAudio.positionStream.listen((e) => setState(() => position = e));

    // Position Tracking
    JustAudio.positionStream
        .timeout(const Duration(seconds: 5))
        .listen((e) => STORAGE.progress.put(current?.id ?? "null", {
              "position": JustAudio.position.inMilliseconds,
              "index": JustAudio.currentIndex,
            }));

    return this;
  }

  @override
  Future<void> dispose() async {
    super.dispose();
    JustAudio.dispose();
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
