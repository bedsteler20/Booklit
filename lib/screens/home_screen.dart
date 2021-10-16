// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:plexlit/model/model.dart';

// Project imports:
import 'package:plexlit/globals.dart';
import 'package:plexlit/helpers/context.dart';
import 'package:plexlit/widgets/widgets.dart';

class HomeScreen extends StatelessWidget {
  static Route<dynamic> route() => MaterialPageRoute(
        builder: (context) => const HomeScreen(),
      );

  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverAppBar(
            title: Text(
              "Home",
              textScaleFactor: 1.35,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          SliverList(
              delegate: SliverChildListDelegate([
          FutureBuilder<List<MediaItem>>(
              future: repository.data!.getCollections(),
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
              future: repository.data!.getGenres(),
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
              future: repository.data!.getGenres(),
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
              future: repository.data!.getGenres(),
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
