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

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: MaterialButton(
          minWidth: 70,
          padding: const EdgeInsets.all(10),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          color: context.buttonColor,
          onPressed: () {
            // Prevents progress bar from going off screen
            final newTime = player.position.value + Duration(seconds: time);
            if (newTime.inSeconds < 0) {
              player.seek(const Duration());
            } else if (newTime.inSeconds > player.duration.value.inSeconds) {
              player.seek(player.duration.value);
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
          )),
    );
  }
}
