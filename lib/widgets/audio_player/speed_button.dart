// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:build_context/src/build_context_impl.dart';

// Project imports:
import 'package:plexlit/helpers/context.dart';
import 'package:plexlit/service/service.dart';
import '../flutter_helpers.dart';

class SpeedButton extends StatelessWidget {
  const SpeedButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final player = context.find<AudioPlayerService>();

    return StreamBuilder<double>(
      stream: player.speedStream,
      builder: (context, AsyncSnapshot<double> snapshot) {
        return MaterialButton(
          onPressed: () => showDialog(context: context, builder: dialog),
          minWidth: 70,
          padding: const EdgeInsets.all(8),
          shape: const CircleBorder(),
          child: Padding(
            padding: const EdgeInsets.all(9.0),
            child: Text(
              (snapshot.data ?? 1.0).toStringAsFixed(2) + "x",
              textScaleFactor: 1.25,
              style: context.textTheme.button!.copyWith(color: context.textTheme.caption!.color),
            ),
          ),
        );
      },
    );
  }

  Widget dialog(BuildContext context) {
    final player = context.find<AudioPlayerService>();

    return StreamBuilder<double>(
      stream: player.speedStream,
      builder: (context, snapshot) => SimpleDialog(
        title: const Text("Plackback Speed"),
        children: [
          const Divider(),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                (snapshot.data ?? 1.0).toStringAsFixed(2) + "x",
                style: context.textTheme.headline3!.copyWith(color: context.theme.colorScheme.onSurface),
              ),
            ),
          ),
          Slider(
            value: snapshot.data ?? 1,
            onChanged: (val) => null,
            min: 0.5,
            max: 3,
            divisions: 50,
          ),
          const Divider(),

          // Skip Scilence Switch
          StreamBuilder<bool>(
            stream: player.skipSilenceEnabledStream,
            builder: (context, snapshot) => RowContainer(
              padding: const EdgeInsets.all(12.0),
              children: [
                Expanded(
                    child: Text(
                  "Skip Silence",
                  style: context.textTheme.button,
                )),
                Switch(
                  activeColor: context.theme.colorScheme.primary,
                  value: snapshot.data ?? false,
                  onChanged: (val) => null,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
