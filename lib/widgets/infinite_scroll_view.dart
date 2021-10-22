// Project imports:
import 'package:plexlit/plexlit.dart';

class InfiniteScrollView extends StatefulWidget {
  const InfiniteScrollView({
    required this.controller,
    required this.parent,
    this.gridMode = false,
    Key? key,
  }) : super(key: key);

  final MediaItem parent;
  final bool gridMode;
  final ScrollController controller;

  Future<List<MediaItem>> query({int limit = 50, int start = 0}) {
    switch (parent.type) {
      case MediaItemType.author:
        return repository.data!
            .getAuthor(parent.id, limit: limit, start: start)
            .then((v) => v.books);

      case MediaItemType.genre:
        return repository.data!.getGenre(parent.id, limit: limit, start: start);
      case MediaItemType.collection:
        return repository.data!.getCollection(parent.id, limit: limit, start: start);
      default:
        throw "can't find repository query for ${parent.type.toString()}";
    }
  }

  @override
  _InfiniteScrollViewState createState() => _InfiniteScrollViewState();
}

class _InfiniteScrollViewState extends State<InfiniteScrollView> {
  static const _querySize = 50;

  List<MediaItem> children = [];
  bool isLoading = true;
  bool isComplete = false;

  Object? error;

  @override
  void initState() {
    super.initState();

    try {
      widget.query(limit: _querySize, start: 0).then((value) {
        children.addAll(value);
        if (value.length < _querySize) isComplete = true;
        isLoading = false;
        setState(() {});
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }

    // Fetch more data when bottom of page is reached
    widget.controller.addListener(
      () {
        try {
          if (widget.controller.position.pixels + 100 >=
              widget.controller.position.maxScrollExtent) {
            if (!isLoading && !isComplete) {
              isLoading = true;
              widget.query(limit: _querySize, start: children.length).then((value) {
                children.addAll(value);
                if (value.length < _querySize) isComplete = true;
                isLoading = false;
                setState(() {});
              });
            }
          }
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
        }
      },
    );
  }

  Future<void> refresh() async {
    try {
      if (!isLoading) {
        isLoading = true;
        widget.query(limit: _querySize, start: 0).then((value) {
          children = value;
          if (value.length < _querySize) isComplete = true;
          isLoading = false;
          setState(() {});
        });
      }
    } catch (e) {
      widget.query(limit: _querySize, start: 0).then((value) {
        children.addAll(value);
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
          controller: widget.controller,
          slivers: [
            if (widget.gridMode)
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
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
