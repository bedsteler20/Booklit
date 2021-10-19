import 'package:flutter/material.dart';
import 'package:plexlit/helpers/context.dart';
import 'package:plexlit/model/model.dart';
import 'package:plexlit/providers/downloads_provider.dart';
import 'package:plexlit/widgets/helper_widgets/flutter_helpers.dart';
import 'package:plexlit/widgets/layout/downloading_list_item.dart';
import 'package:plexlit/widgets/widgets.dart';
import 'package:provider/src/provider.dart';

class DownloadsScreen extends StatelessWidget {
  const DownloadsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        DownloadingItemsList(),
        FutureBuilderPlus<List<MediaItem>>(
          future: context.read<DownloadsProvider>().savedAudiobooks(),
          completed: (context, items) {
            return SliverList(
              delegate: SliverChildListDelegate([
                for (var item in items) ListItem(item),
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

class DownloadingItemsList extends StatelessWidget {
  const DownloadingItemsList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final inProgress = context.watch<DownloadsProvider>();

    if (inProgress.inProgress.isEmpty) return SliverList(delegate: SliverChildListDelegate([]));

    return SliverList(
        delegate: SliverChildListDelegate([
      ListTile(title: Text("Downloading..", style: context.headline6)),
      for (var item in inProgress.inProgress.keys)
        ValueListenableBuilder<double>(
          valueListenable: inProgress.inProgress[item]!,
          builder: (context, value, __) => DownloadingListItem(
            item,
            onCancel: () {},
            progress: value,
          ),
        )
    ]));
  }
}
