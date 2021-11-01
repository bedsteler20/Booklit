import 'package:booklit/booklit.dart';

class MiniplayerMoreButton extends StatelessWidget {
  const MiniplayerMoreButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var player = context.find<AudioProvider>();

    return PopupMenuButton(
      icon: const Icon(Icons.more_vert),
      color: context.theme.scaffoldBackgroundColor,
      itemBuilder: (context) {
        return [
          PopupMenuItem(
            child: ListTile(
              visualDensity: VisualDensity.compact,
              leading: const Icon(Icons.speed_rounded),
              contentPadding: const EdgeInsets.all(2),
              title: const Text("Playback Speed"),
              onTap: () => showDialog(context: context, builder: (_) => const PlayerSpeedDialog()),
            ),
          ),
          PopupMenuItem(
            child: ListTile(
              visualDensity: VisualDensity.compact,
              leading: const Icon(Icons.book_rounded),
              contentPadding: const EdgeInsets.all(2),
              title: const Text("Chapter"),
              onTap: () => showDialog(context: context, builder: (_) => const ChapterPicker()),
            ),
          ),
          PopupMenuItem(
            child: ListTile(
              visualDensity: VisualDensity.compact,
              leading: const Icon(Icons.stop_rounded),
              contentPadding: const EdgeInsets.all(2),
              title: const Text("Stop"),
              onTap: () {
                player.stop();
                Navigator.pop(context);
              },
            ),
          ),
          PopupMenuItem(
            child: ListTile(
              visualDensity: VisualDensity.compact,
              leading: const Icon(Icons.timer_rounded),
              contentPadding: const EdgeInsets.all(2),
              title: const Text("Sleep Timer"),
              onTap: () {
                Navigator.pop(context);
                SleepTimerDialog.show(context);
              },
            ),
          ),
        ];
      },
    );
  }
}