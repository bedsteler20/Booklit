// Project imports:
import 'package:booklit/booklit.dart';

class SleepTimerDialog extends StatelessWidget {
  const SleepTimerDialog({Key? key}) : super(key: key);

  static Future show(BuildContext context) =>
      showDialog(context: context, builder: (c) => const SleepTimerDialog());

  @override
  Widget build(BuildContext context) {
    final timerType = context.select<AudioProvider, SleepTimerType?>((e) => e.sleepTimerType);
    final player = context.read<AudioProvider>();
    return SimpleDialog(
      children: [
        ListTile(
          title: const Text("5 minutes"),
          selected: timerType == SleepTimerType.min5,
          onTap: () => player.startSleepTimer(SleepTimerType.min5),
        ),
        ListTile(
          title: const Text("15 minutes"),
          selected: timerType == SleepTimerType.min15,
          onTap: () => player.startSleepTimer(SleepTimerType.min15),
        ),
        ListTile(
          title: const Text("30 minutes"),
          selected: timerType == SleepTimerType.min30,
          onTap: () => player.startSleepTimer(SleepTimerType.min30),
        ),
        ListTile(
          title: const Text("40 minutes"),
          selected: timerType == SleepTimerType.min40,
          onTap: () => player.startSleepTimer(SleepTimerType.min40),
        ),
        ListTile(
          title: const Text("End Of Chapter"),
          selected: timerType == SleepTimerType.chapterEnd,
          onTap: () => player.startSleepTimer(SleepTimerType.chapterEnd),
        ),
      ],
    );
  }
}
