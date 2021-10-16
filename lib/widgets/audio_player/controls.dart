// Flutter imports:
import 'package:flutter/material.dart';
import 'package:plexlit/model/model.dart';

// Package imports:

// Project imports:
import 'package:plexlit/helpers/context.dart';
import 'package:plexlit/service/service.dart';
import 'play_button.dart';
import 'seek_button.dart';
import 'speed_button.dart';
import 'timeline.dart';

/// Buttons, Timeline & title widget
class AudioPlayerControls extends StatelessWidget {
  const AudioPlayerControls({Key? key}) : super(key: key);

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
            SeekButton(time: -30),
            PlayButton(),
            SeekButton(time: 30),
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
        child: ValueListenableBuilder<Chapter?>(
          valueListenable: player.chapter,
          builder: (context, chapter, _) {
            return Text(
              chapter?.name ?? "Chapter Null",
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: context.bodyText1!.copyWith(fontSize: 24),
              textAlign: TextAlign.center,
            );
          },
        ),
      ),
    );
  }
}
