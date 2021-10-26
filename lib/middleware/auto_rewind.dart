// Dart imports:
import 'dart:async';

/// Seeks player back when resuming playback.
abstract class AutoRewind {
  Timer? _timer;

  /// How long to seek back when resuming playback.
  int autoRewindSeconds = 0;

  void startAutoRemindTimer() {
    autoRewindSeconds = 0;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      // Max out at 20 seconds.
      if (timer.tick == 20) {
        timer.cancel();
        _timer = null;

        return;
      }

      autoRewindSeconds++;
    });
  }

  void stopAutoRemindTimer() {
    _timer?.cancel();
    _timer = null;
  }
}
