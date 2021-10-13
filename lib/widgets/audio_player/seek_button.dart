// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:plexlit/helpers/helpers.dart';
import 'package:plexlit/service/service.dart';

class SeekButton extends StatelessWidget {
  const SeekButton({required this.time, Key? key}) : super(key: key);
  final int time;

  @override
  Widget build(BuildContext context) {
    final player = context.find<AudioPlayerService>();

    return MaterialButton(
        minWidth: 70,
        padding: const EdgeInsets.all(8),
        shape: const CircleBorder(),
        onPressed: () {
          // Prevents progress bar from going off screen
          final newTime = player.position + Duration(seconds: time);
          if (newTime.inSeconds < 0) {
            player.seek(const Duration(seconds: 0));
          } else if (newTime.inSeconds > player.duration!.inSeconds) {
            player.seek(player.duration);
          } else {
            player.seek(newTime);
          }
        },
        child: Icon(
          () {
            if (time == (-30)) return Icons.replay_30;
            if (time == (-10)) return Icons.replay_10;
            if (time == (-5)) return Icons.replay_5;
            if (time == (30)) return Icons.forward_30;
            if (time == (10)) return Icons.forward_10;
            if (time == (5)) return Icons.forward_5;
            return Icons.error;
          }(),
          size: 40,
          color: Theme.of(context).textTheme.caption!.color,
        ));
  }
}
