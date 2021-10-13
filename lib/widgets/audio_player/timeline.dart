// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';

// Project imports:
import 'package:plexlit/helpers/context.dart';
import 'package:plexlit/service/service.dart';

// Wraper around streams
class Timeline extends StatelessWidget {
  const Timeline({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final player = context.find<AudioPlayerService>();
    return StreamBuilder<Duration?>(
      stream: player.durationStream,
      builder: (context, total) {
        return StreamBuilder<Duration?>(
          stream: player.positionStream,
          builder: (context, progress) {
            return StreamBuilder<Duration?>(
              stream: player.bufferedPositionStream,
              builder: (context, bufferd) {
                return ProgressBar(
                  thumbRadius: 8,
                  barHeight: 4,
                  onSeek: player.seek,
                  progress: progress.data ?? const Duration(seconds: 0),
                  total: total.data ?? const Duration(seconds: 60),
                  buffered: bufferd.data ?? const Duration(seconds: 0),
                );
              },
            );
          },
        );
      },
    );
  }
}
