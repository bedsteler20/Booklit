// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:build_context/src/build_context_impl.dart';
import 'package:plexlit_api/plexlit_api.dart';

// Project imports:
import 'package:plexlit/helpers/context.dart';
import 'package:plexlit/service/service.dart';
import 'play_button.dart';
import 'seek_button.dart';
import 'speed_button.dart';
import 'timeline.dart';

/// Buttons, Timeline & title widget
class AudioPlayerControlls extends StatelessWidget {
  const AudioPlayerControlls({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Builder(builder: title),
        Container(
          padding: const EdgeInsets.only(bottom: 15),
          width: MediaQuery.of(context).size.width * 0.8,
          child: const Timeline(),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: const [
            SpeedButton(),
            SeekButton(time: -30),
            PlayButton(),
            SeekButton(time: 30),
            SpeedButton(),
          ],
        ),
      ],
    );
  }

  Widget title(BuildContext context) {
    final player = context.find<AudioPlayerService>();
    return Container(
      width: context.width * 0.8,
      padding: const EdgeInsets.only(top: 50, bottom: 25),
      child: Center(
        child: StreamBuilder<Chapter?>(
          stream: player.currentChapterStream,
          builder: (context, snapshot) {
            return Text(
              snapshot.data?.name ?? "Chapter Null",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: context.textTheme.bodyText1!.copyWith(fontSize: 24),
            );
          },
        ),
      ),
    );
  }
}
