import 'package:plexlit/plexlit.dart';

class PlayerSpeedDialog extends StatelessWidget {
  const PlayerSpeedDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final player = context.find<AudioProvider>();
    var speed = context.select<AudioProvider, double>((v) => v.speed);

    return SimpleDialog(
      title: const Text("Playback Speed"),
      children: [
        const Divider(),
        Center(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              (speed).toStringAsFixed(2) + "x",
              style: context.headline3!.copyWith(color: context.theme.colorScheme.onSurface),
            ),
          ),
        ),
        Slider(
          value: speed,
          onChanged: player.setSpeed,
          min: 0.5,
          max: 3,
          divisions: 50,
        ),
      ],
    );
  }
}
