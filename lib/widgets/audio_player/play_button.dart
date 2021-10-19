import 'package:plexlit/plexlit.dart';

// Package imports:
import 'package:just_audio/just_audio.dart';


class PlayButton extends StatelessWidget {
  const PlayButton({Key? key, this.desktop = false}) : super(key: key);
  final bool desktop;

  Widget buildButton(
    BuildContext context,
    Function() onPressed,
    Widget icon,
  ) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: desktop ? 0 : 5),
      height: 60,
      width: desktop ? 60 : 90,
      decoration: BoxDecoration(
        color: desktop ? context.theme.cardColor : context.buttonColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: IconButton(
        iconSize: 40,
        padding: const EdgeInsets.all(10),
        onPressed: onPressed,
        color: Theme.of(context).textTheme.caption!.color,
        icon: icon,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final player = context.find<AudioProvider>();
    var playerState = context.select<AudioProvider, PlayerState>((v) => v.playerState);

    if (playerState.processingState == ProcessingState.buffering) {
      return buildButton(
        context,
        player.play,
        const SizedBox(
          height: 32,
          width: 32,
          child: CircularProgressIndicator(color: Colors.white),
        ),
      );
    } else if (!playerState.playing) {
      return buildButton(
        context,
        player.play,
        const Icon(Icons.play_arrow_rounded),
      );

      // Displayed when playing
    } else if (playerState.processingState != ProcessingState.completed) {
      return buildButton(
        context,
        player.pause,
        const Icon(Icons.pause_rounded),
      );

      //Displayed when  audiobook has ended
    } else {
      return buildButton(
        context,
        () => player.seek(Duration.zero),
        const Icon(Icons.replay_rounded),
      );
    }
  }
}
