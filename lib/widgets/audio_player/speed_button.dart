import 'package:plexlit/plexlit.dart';

class SpeedButton extends StatelessWidget {
  const SpeedButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final player = context.find<AudioProvider>();
    final speed = context.select<AudioProvider, double>((e) => e.speed);
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
  }
}
