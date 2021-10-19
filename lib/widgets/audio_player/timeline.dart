// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';

// Project imports:
import 'package:plexlit/helpers/context.dart';
import 'package:plexlit/service/service.dart';

class Timeline extends StatefulWidget {
  const Timeline({Key? key, this.labelLocation = TimeLabelLocation.below}) : super(key: key);

  final TimeLabelLocation labelLocation;

  @override
  State<Timeline> createState() => _TimelineState();
}

class _TimelineState extends State<Timeline> {
  @override
  void initState() {
    super.initState();
    final player = context.find<AudioPlayerService>();

    player.bufferedPosition.addListener(() => setState(() {}));
    player.position.addListener(() => setState(() {}));
    player.duration.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    super.dispose();
    final player = context.find<AudioPlayerService>();

    player.bufferedPosition.removeListener(() => setState(() {}));
    player.position.removeListener(() => setState(() {}));
    player.duration.removeListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    final player = context.find<AudioPlayerService>();

    return ProgressBar(
      thumbRadius: 8,
      barHeight: 4,
      onSeek: player.seek,
      progress: player.position.value,
      total: player.duration.value,
      buffered: player.bufferedPosition.value,
      timeLabelLocation: TimeLabelLocation.sides,
    );
  }
}
