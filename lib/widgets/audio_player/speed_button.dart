// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:plexlit/helpers/context.dart';
import 'package:plexlit/service/service.dart';
import 'package:plexlit/widgets/dialogs/player_speed_dialog.dart';
import '../flutter_helpers.dart';

// Package imports:

class SpeedButton extends StatelessWidget {
  const SpeedButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final player = context.find<AudioPlayerService>();

    return ValueListenableBuilder<double>(
      valueListenable: player.speed,
      builder: (context, speed, _) {
        return MaterialButton(
          onPressed: () => showDialog(context: context, builder: (_) => const PlayerSpeedDialog()),
          minWidth: 70,
          padding: const EdgeInsets.all(8),
          shape: const CircleBorder(),
          child: Padding(
            padding: const EdgeInsets.all(9.0),
            child: Text(
              (speed).toStringAsFixed(2) + "x",
              textScaleFactor: 1.25,
              style: context.textTheme.button!.copyWith(color: context.textTheme.caption!.color),
            ),
          ),
        );
      },
    );
  }
}
