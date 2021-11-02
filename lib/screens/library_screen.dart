// Project imports:
import 'package:booklit/booklit.dart';
import 'package:booklit/core/scroll_page_state.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({
    Key? key,
  }) : super(key: key);
  @override
  LibraryScreenState createState() => LibraryScreenState();
}

class LibraryScreenState extends ScrollPageState<LibraryScreen, MediaItem> {
  @override
  final querySize = 50;

  bool gridMode = false;

  @override
  Future<List<MediaItem>> fetchData() async =>
      REPOSITORY.data!.getAudiobooks(limit: querySize, start: itemsFetched);

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: refreshData,
      child: Scrollbar(
        child: CustomScrollView(
          scrollDirection: Axis.vertical,
          controller: scrollController,
          slivers: [
            const SliverAppBar(
              title: Text("Library"),

            ),

            SliverList(delegate: SliverChildListDelegate(items.map((e) => ListItem(e)).toList())),
            const SliverPadding(
              padding: EdgeInsets.only(bottom: 80),
            )
          ],
        ),
      ),
    );
  }
}
