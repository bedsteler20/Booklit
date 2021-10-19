import 'package:plexlit/plexlit.dart';

class DownloadsScreen extends StatelessWidget {
  const DownloadsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final inProgress = context.watch<DownloadsProvider>().inProgress;

    return CustomScrollView(
      slivers: [
        const SliverAppBar(title: Text("Downloads")),
        FutureBuilderPlus<List<MediaItem>>(
          future: context.read<DownloadsProvider>().savedAudiobooks(),
          completed: (context, items) {
            return SliverList(
              delegate: SliverChildListDelegate([
                for (var item in items) ListItem(item),
                for (var item in inProgress.keys)
                  ValueListenableBuilder<double>(
                    valueListenable: inProgress[item]!,
                    builder: (context, value, __) => DownloadingListItem(
                      item,
                      onCancel: () {},
                      progress: value,
                    ),
                  )
              ]),
            );
          },
          loading: (c) => SliverFillViewport(
            delegate: SliverChildBuilderDelegate((_, __) => const LoadingWidget()),
          ),
          error: (c, e) => SliverFillViewport(
            delegate: SliverChildBuilderDelegate((_, __) => ErrorWidget(e!)),
          ),
        ),
      ],
    );
  }
}
