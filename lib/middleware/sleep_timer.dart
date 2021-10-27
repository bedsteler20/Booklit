import 'dart:async';

import 'package:plexlit/plexlit.dart';

abstract class SleepTimer {
  StreamSubscription? _indexSubscription;
  Stream<Duration>? _positionStream = JustAudio.createPositionStream();

  SleepTimerType? sleepTimerType;

  Duration? sleepTimerLength;

  int? _totalTicks;
  int _currentTick = 0;

  Timer? _timer;

  void startSleepTimer(SleepTimerType type) {
    stopSleepTimer();

    if (sleepTimerType == type) return;

    sleepTimerType = type;
    if (type == SleepTimerType.chapterEnd) {
      _indexSubscription = JustAudio.currentIndexStream.listen((event) {
        JustAudio.pause();
        stopSleepTimer();
      });
    } else {
      switch (type) {
        case SleepTimerType.min5:
          _totalTicks = const Duration(minutes: 5).inSeconds;
          break;
        case SleepTimerType.min15:
          _totalTicks = const Duration(minutes: 15).inSeconds;
          break;
        case SleepTimerType.min30:
          _totalTicks = const Duration(minutes: 30).inSeconds;
          break;
        case SleepTimerType.min40:
          _totalTicks = const Duration(minutes: 40).inSeconds;
          break;
        default:
      }

      _timer = Timer.periodic(1.seconds, (timer) {
        if (JustAudio.playing) {
          if (_totalTicks != null) {
            _currentTick++;
            if (_currentTick == _totalTicks) {
              JustAudio.pause();
              stopSleepTimer();
            }
          }
        }
      });
    }
  }

  void stopSleepTimer() {
    sleepTimerType = null;
    _totalTicks = null;
    _currentTick = 0;
    _timer?.cancel();
    _indexSubscription?.cancel();
  }
}

enum SleepTimerType { chapterEnd, min15, min5, min30, min40 }
