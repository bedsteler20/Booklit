// Package imports:
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';

// Project imports:
import 'package:booklit/booklit.dart';

class Timeline extends StatelessWidget {
  const Timeline({Key? key, this.labelLocation = TimeLabelLocation.below}) : super(key: key);

  final TimeLabelLocation labelLocation;
  @override
  Widget build(BuildContext context) {
    return ProgressBar(
      thumbRadius: 8,
      barHeight: 4,
      onSeek: context.read<AudioProvider>().seek,
      progress: context.select<AudioProvider, Duration>((v) => v.position),
      total: context.select<AudioProvider, Duration>((v) => v.duration),
      buffered: context.select<AudioProvider, Duration>((v) => v.bufferedPosition),
      timeLabelLocation: TimeLabelLocation.sides,
    );
  }
}
