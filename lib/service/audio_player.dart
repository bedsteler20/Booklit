// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:just_audio/just_audio.dart';
import 'package:plexlit_api/plexlit_api.dart';

// Project imports:
import 'package:plexlit/helpers/audiobook_extention.dart';
import 'package:plexlit/helpers/context.dart';
import 'package:plexlit/storage.dart';

class AudioPlayerService extends AudioPlayer implements ChangeNotifier {
  //final audio = AudioPlayer();

  late final BuildContext context;
  late final Timer progressTracker;
  final _audioBook = ValueNotifier<Audiobook?>(null);

  Audiobook? get audioBook => _audioBook.value;

  set audioBook(Audiobook? book) {
    if (book == null) throw "Cant play audio book if it is null";
    setAudioSource(book.toAudioSource());
    _audioBook.value = book;

    // Load progress
    if (Storage.progress.containsKey(book.id)) {
      seek(Duration(seconds: Storage.progress.get(book.id) ?? 0));
    }
  }

  Future<AudioPlayerService> init() async {
    // Start progress tracker
    progressTracker = Timer.periodic(const Duration(seconds: 10), (timer) {
      if (audioBook == null) return;
      context
          .find<PlexlitApiClient>()
          .reportTimelinePosition(audioBook!, isPaused: !playing, position: position);
      Storage.progress.put(audioBook!.id, position.inSeconds);
    });

    return this;
  }

  @override
  Future<void> seek(Duration? position, {int? index}) async {
    super.seek(position, index: index);
    if (position == null && audioBook == null) return;
    Storage.progress.put(audioBook!.id, position!.inSeconds);
  }

  Chapter? get currentChapter => audioBook?.chapters[currentIndex ?? 0];
  Stream<Chapter?> get currentChapterStream =>
      currentIndexStream.map((e) => audioBook?.chapters[e ?? 0]);

  @override
  Future<void> dispose() async {
    _audioBook.dispose();
    super.dispose();
  }

  @override
  void notifyListeners() => _audioBook.notifyListeners();
  @override
  void addListener(void Function() listener) => _audioBook.addListener(listener);
  @override
  void removeListener(void Function() listener) => _audioBook.removeListener(listener);
  @override
  bool get hasListeners => _audioBook.hasListeners;
}
