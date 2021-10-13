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
    return StreamBuilder<PlayerState>(
      stream: player.playerStateStream,
      builder: (context, snapshot) {
        final state = snapshot.data?.processingState;
        final playing = snapshot.data?.playing;
        final buffering = state == ProcessingState.loading || state == ProcessingState.buffering;

        if (buffering) {
          return MaterialButton(
            minWidth: 0,
            onPressed: player.play,
            color: Theme.of(context).colorScheme.primary,
            child: const SizedBox(
              height: 32,
              width: 32,
              child: CircularProgressIndicator(color: Colors.white),
            ),
            padding: const EdgeInsets.all(12),
            shape: const CircleBorder(),
          );
        } else if (playing != true) {
          return MaterialButton(
            minWidth: 0,
            onPressed: player.play,
            color: Theme.of(context).colorScheme.primary,
            child: const Icon(
              Icons.play_arrow_rounded,
              size: 40,
            ),
            padding: const EdgeInsets.all(8),
            shape: const CircleBorder(),
          );

          // Displayed when playing
        } else if (state != ProcessingState.completed) {
          return MaterialButton(
            minWidth: 0,
            onPressed: player.pause,
            color: Theme.of(context).colorScheme.primary,
            child: const Icon(
              Icons.pause_rounded,
              size: 40,
            ),
            padding: const EdgeInsets.all(8),
            shape: const CircleBorder(),
          );

          //Displayed when  audiobook has ended
        } else {
          return MaterialButton(
            minWidth: 0,
            onPressed: () => player.seek(Duration.zero),
            color: Theme.of(context).colorScheme.primary,
            child: const Icon(
              Icons.replay_rounded,
              size: 40,
            ),
            padding: const EdgeInsets.all(8),
            shape: const CircleBorder(),
          );
        }
      },
    );
  }
}
