// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';
import 'package:plexlit/model/model.dart';
import 'package:provider/src/provider.dart';

// Project imports:
import 'package:plexlit/helpers/audiobook_extention.dart';
import 'package:plexlit/helpers/context.dart';
import 'package:plexlit/providers/api_provider.dart';
import 'package:plexlit/storage.dart';

class AudioPlayerService {
  static final _audio = AudioPlayer();

  /// [Listenable] value that represents the currently playing audiobook
  final current = ValueNotifier<Audiobook?>(null);

  final chapter = ValueNotifier<Chapter?>(null);

  final playerState = ValueNotifier<PlayerState>(PlayerState(false, ProcessingState.buffering));

  final speed = ValueNotifier<double>(1.0);

  /// Only on Android
  final skipSilence = ValueNotifier<bool>(false);

  /// The duration of the current audio or null if unknown.
  final duration = ValueNotifier<Duration>(const Duration(seconds: 60));

  /// The current position of the player.
  final position = ValueNotifier<Duration>(const Duration());

  /// The position up to which buffered audio is available.
  final bufferedPosition = ValueNotifier<Duration>(const Duration());

  late final BuildContext context;

  Future<void> play() => _audio.play();

  Future<void> pause() => _audio.pause();

  Future<void> setSkipSilence(bool b) => _audio.setSkipSilenceEnabled(b);

  Future<void> setSpeed(double speed) => _audio.setSpeed(speed);

  Future<void> seek(Duration? position, {int? chapterIndex}) async {
    _audio.seek(position, index: chapterIndex);
  }

  Future<void> load(Audiobook? book) async {
    if (book == null) throw "Cant play audio book if it is null";
    chapter.value = book.chapters[0];
    current.value = book;

    await _audio.setAudioSource(
      book.toAudioSource(),
      preload: true,
      // initialIndex: Storage.progress.get(book.id)?["index"],
      // initialPosition: Duration(milliseconds: Storage.progress.get(book.id)?["position"] ?? 0),
    );
  }

  Future<AudioPlayerService> init() async {
    _audio.currentIndexStream.listen((e) => chapter.value = current.value?.chapters[e ?? 0]);
    _audio.durationStream.listen((e) => duration.value = e ?? const Duration());
    _audio.bufferedPositionStream.listen((e) => bufferedPosition.value = e);
    _audio.playerStateStream.listen((e) => playerState.value = e);
    _audio.speedStream.listen((e) => speed.value = e);
    _audio.skipSilenceEnabledStream.listen((e) => skipSilence.value = e);
    _audio.positionStream.listen((e) => position.value = e);

    _audio.positionStream
        .timeout(const Duration(seconds: 5))
        .listen((e) => Storage.progress.put(current.value?.id ?? "null", {
              "position": _audio.position.inMilliseconds,
              "index": _audio.currentIndex,
            }));

    return this;
  }

  Future<void> dispose() async {
    current.dispose();
    _audio.dispose();
  }
}
