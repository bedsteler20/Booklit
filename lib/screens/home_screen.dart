// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:go_router/go_router.dart';
import 'package:plexlit_api/plexlit_api.dart';
import 'package:sliver_header_delegate/sliver_header_delegate.dart';

// Project imports:
import 'package:plexlit/helpers/context.dart';
import 'package:plexlit/providers/api_provider.dart';
import 'package:plexlit/routes.dart';
import 'package:plexlit/widgets/widgets.dart';

class HomeScreen extends StatelessWidget {
  static Route<dynamic> route() => MaterialPageRoute(
        builder: (context) => const HomeScreen(),
      );

  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final client = ApiProvider.server;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverList(
              delegate: SliverChildListDelegate([
            FutureBuilder<List<MediaItem>>(
              future: client.getCollections(),
              builder: (ctx, snap) {
                if (snap.hasError) {
                  return const Text("Error");
                } else if (snap.hasData) {
                  return MediaRowWidget(
                    items: snap.data!,
                    title: "Collections",
                    onShowMore: () => context.to("/collections"),
                  );
                } else {
                  return const Text("Loading");
                }
              },
            ),
            FutureBuilder<List<MediaItem>>(
              future: client.getGenres(),
              builder: (ctx, snap) {
                if (snap.hasError) {
                  return const Text("Error");
                } else if (snap.hasData) {
                  return MediaRowWidget(
                    items: snap.data!,
                    title: "Genres",
                    onShowMore: () => context.to("/genres"),
                  );
                } else {
                  return const Text("Loading");
                }
              },
            ),
            FutureBuilder<List<MediaItem>>(
              future: client.getGenres(),
              builder: (ctx, snap) {
                if (snap.hasError) {
                  return const Text("Error");
                } else if (snap.hasData) {
                  return MediaRowWidget(
                    items: snap.data!,
                    title: "Genres",
                    onShowMore: () => context.to("/genres"),
                  );
                } else {
                  return const Text("Loading");
                }
              },
            ),
            FutureBuilder<List<MediaItem>>(
              future: client.getGenres(),
              builder: (ctx, snap) {
                if (snap.hasError) {
                  return const Text("Error");
                } else if (snap.hasData) {
                  return MediaRowWidget(
                    items: snap.data!,
                    title: "Genres",
                    onShowMore: () => context.to("/genres"),
                  );
                } else {
                  return const Text("Loading");
                }
              },
            ),
            // FutureBuilder<List<PlexObject>>(
            //   future: plex.library.unRead(),
            //   builder: (ctx, snap) {
            //     if (snap.hasError) {
            //       return const Text("Error");
            //     } else if (snap.hasData) {
            //       return MediaRowWidget(
            //         mediaList: snap.data!,
            //       );
            //     } else {
            //       return const Text("Loading");
            //     }
            //   },
            // ),
          ])),
        ],
      ),
    );
  }
}
