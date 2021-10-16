// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:just_audio/just_audio.dart';

// Project imports:
import 'package:plexlit/helpers/context.dart';
import 'package:plexlit/service/service.dart';

class PlayButton extends StatelessWidget {
  const PlayButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final player = context.find<AudioPlayerService>();
    return ValueListenableBuilder<PlayerState>(
      valueListenable: player.playerState,
      builder: (context, state, _) {
        if (state.processingState == ProcessingState.buffering) {
          return MaterialButton(
            minWidth: 90,
            onPressed: player.play,
            color: context.buttonColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: const SizedBox(
              height: 32,
              width: 32,
              child: CircularProgressIndicator(color: Colors.white),
            ),
            padding: const EdgeInsets.all(10),
            // shape: const CircleBorder(),
          );
        } else if (!state.playing) {
          return MaterialButton(
            minWidth: 90,
            onPressed: player.play,
            color: context.buttonColor,
            child: const Icon(
              Icons.play_arrow_rounded,
              size: 40,
            ),
            padding: const EdgeInsets.all(10),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),

            // shape: const CircleBorder(),
          );

          // Displayed when playing
        } else if (state.processingState != ProcessingState.completed) {
          return MaterialButton(
            minWidth: 90,
            onPressed: player.pause,
            color: context.buttonColor,
            child: const Icon(
              Icons.pause_rounded,
              size: 40,
            ),
            padding: const EdgeInsets.all(10),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          );

          //Displayed when  audiobook has ended
        } else {
          return MaterialButton(
            minWidth: 90,
            onPressed: () => player.seek(Duration.zero),
            color: context.buttonColor,
            child: const Icon(
              Icons.replay_rounded,
              size: 40,
            ),
            padding: const EdgeInsets.all(10),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),

            // shape: const CircleBorder(),
          );
        }
      },
    );
  }
}
