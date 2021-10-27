// Project imports:
import 'package:plexlit/plexlit.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  static List<MediaItem>? _collections;
  static List<MediaItem>? _genres;

  static bool _collectionsLoaded = false;
  static bool _genresLoaded = false;

  @override
  void initState() {
    super.initState();

    if (!_collectionsLoaded) {
      context.repository?.getCollections().then((value) {
        _collections = value;
        _collectionsLoaded = true;
        setState(() {});
      });
    }

    if (!_genresLoaded) {
      context.repository?.getGenres().then((value) {
        _genres = value;
        _genresLoaded = true;
        setState(() {});
      });
    }

    // Clear cache when repo changes
    REPOSITORY.addListener(() {
      _collectionsLoaded = false;
      _genresLoaded = false;
      _collections = null;
      _genres = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final downloaded = context.select<DownloadsProvider, List<MediaItem>>((s) => s.downloaded);

    if (!_collectionsLoaded || !_genresLoaded) {
      return const Center(child: CircularProgressIndicator());
    } else {
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
              if (downloaded.isNotEmpty)
                MediaRowWidget(
                  items: downloaded,
                  title: "Downloads",
                  onShowMore: () => context.to("/downloads"),
                ),
              if (_collectionsLoaded)
                MediaRowWidget(
                  items: _collections!,
                  title: "Collections",
                  onShowMore: () => context.to("/collections"),
                ),

              if (_genresLoaded)
                MediaRowWidget(
                  items: _genres!,
                  title: "Genres",
                  onShowMore: () => context.to("/genres"),
                )

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
}
