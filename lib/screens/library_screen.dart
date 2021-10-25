// Project imports:
import 'package:plexlit/plexlit.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({
    Key? key,
  }) : super(key: key);
  @override
  LibraryScreenState createState() => LibraryScreenState();
}

class LibraryScreenState extends State<LibraryScreen> {
  static const _querySize = 50;

  static List<MediaItem> children = [];
  static bool isLoading = true;
  static bool isComplete = false;
  static bool gridMode = false;
  static final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    if (children.isEmpty) {
      REPOSITORY.data!.getAudiobooks(limit: _querySize, start: 0).then((value) {
        children.addAll(value);
        if (value.length < _querySize) isComplete = true;
        isLoading = false;
        setState(() {});
      });
    }

    // Fetch more data when bottom of page is reached
    scrollController.addListener(
      () {
        if (scrollController.position.pixels + 100 >= scrollController.position.maxScrollExtent) {
          if (!isLoading && !isComplete) {
            isLoading = true;
            REPOSITORY.data!.getAudiobooks(limit: _querySize, start: children.length).then(
              (value) {
                children.addAll(value);
                if (value.length < _querySize) isComplete = true;
                isLoading = false;
                setState(() {});
              },
            );
          }
        }
      },
    );
  }

  Future<void> refresh() async {
    if (!isLoading) {
      isLoading = true;
      REPOSITORY.data!.getAudiobooks(limit: _querySize, start: 0).then((value) {
        children = value;
        if (value.length < _querySize) isComplete = true;
        isLoading = false;
        setState(() {});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: refresh,
      child: Scrollbar(
        child: CustomScrollView(
          scrollDirection: Axis.vertical,
          controller: scrollController,
          slivers: [
            SliverAppBar(
              title: const Text("Library"),
              actions: [
                IconButton(
                    onPressed: () => setState(() => gridMode = !gridMode),
                    icon: Icon(gridMode ? Icons.grid_on : Icons.list_rounded)),
              ],
            ),
            if (gridMode)
              SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 250,
                    childAspectRatio: 4 / 5,
                  ),
                  delegate: SliverChildListDelegate(children.map((e) => GridItem(e)).toList()),
                ),
              )
            else
              SliverList(
                  delegate: SliverChildListDelegate(children.map((e) => ListItem(e)).toList())),
            const SliverPadding(
              padding: EdgeInsets.only(bottom: 80),
            )
          ],
        ),
      ),
    );
  }
}
