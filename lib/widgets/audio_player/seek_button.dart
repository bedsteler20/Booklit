import 'package:plexlit/plexlit.dart';

class SeekButton extends StatelessWidget {
  const SeekButton({required this.time, Key? key, this.desktop = false}) : super(key: key);
  final int time;
  final bool desktop;

  @override
  Widget build(BuildContext context) {
    final player = context.find<AudioProvider>();

    return Container(
      margin: EdgeInsets.symmetric(horizontal: desktop ? 0 : 5),
      height: 60,
      width: 60,
      decoration: BoxDecoration(
        color: desktop ? context.theme.cardColor : context.buttonColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: IconButton(
          padding: const EdgeInsets.all(10),
          onPressed: () {
            // Prevents progress bar from going off screen
            final newTime = player.position + Duration(seconds: time);
            if (newTime.inSeconds < 0) {
              player.seek(const Duration());
            } else if (newTime.inSeconds > player.duration.inSeconds) {
              player.seek(player.duration);
            } else {
              player.seek(newTime);
            }
          },
          icon: Icon(
            () {
              if (time == (-30)) return Icons.replay_30;
              if (time == (-10)) return Icons.replay_10;
              if (time == (-5)) return Icons.replay_5;
              if (time == (30)) return Icons.forward_30;
              if (time == (10)) return Icons.forward_10;
              if (time == (5)) return Icons.forward_5;
              return Icons.error;
            }(),
            size: 36,
            color: Theme.of(context).textTheme.caption!.color,
          )),
    );
  }
}
