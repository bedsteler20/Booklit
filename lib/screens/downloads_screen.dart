// Project imports:
import 'package:plexlit/plexlit.dart';

class DownloadsScreen extends StatelessWidget {
  const DownloadsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final downloaded = context.select<DownloadsProvider, Iterable<MediaItem>>((s) => s.downloaded);
    final cancel = context.read<DownloadsProvider>().cancel;
    final delete = context.read<DownloadsProvider>().delete;

    final inProgresses =
        context.select<DownloadsProvider, Iterable<MediaItem>>((s) => s.inProgress.keys);

    return CustomScrollView(
      slivers: [
        const SliverAppBar(title: Text("Downloads")),
        SliverList(
          delegate: SliverChildListDelegate([
            for (var item in inProgresses)
              Selector<DownloadsProvider, double?>(
                  selector: (context, s) => s.inProgress[item],
                  builder: (context, value, __) {
                    if (value == null) return const SizedBox();
                    return DownloadingListItem(
                      item,
                      progress: value,
                      onCancel: () => showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text("Cancel Download?"),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text("No"),
                            ),
                            TextButton(
                              onPressed: () {
                                cancel(item);
                                Navigator.pop(context);
                              },
                              child: const Text("Yes"),
                            )
                          ],
                        ),
                      ),
                    );
                  }),
            if (inProgresses.isNotEmpty) const Divider(),
            for (var item in downloaded)
              ListItem(
                item,
                onLongPress: () => showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                          title: Text("Delete ${item.title}"),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text("No"),
                            ),
                            TextButton(
                              onPressed: () {
                                delete(item.id);
                                Navigator.pop(context);
                              },
                              child: const Text("Yes"),
                            )
                          ],
                        )),
              ),
          ]),
        )
      ],
    );
  }
}
