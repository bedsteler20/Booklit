// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:plexlit_api/plexlit_api.dart';

// Project imports:
import 'package:plexlit/widgets/list_item.dart';
import 'grid_item.dart';

class InfiniteScrollView extends StatefulWidget {
  const InfiniteScrollView({
    required this.id,
    required this.controller,
    required this.query,
    this.gridMode = false,
    Key? key,
  }) : super(key: key);

  final String id;
  final bool gridMode;
  final ScrollController controller;
  final Future<List<MediaItem>> Function(String id, {int limit, int start}) query;

  @override
  _InfiniteScrollViewState createState() => _InfiniteScrollViewState();
}

class _InfiniteScrollViewState extends State<InfiniteScrollView> {
  static const _querySize = 50;

  List<MediaItem> children = [];
  bool isLoading = true;
  bool isComplete = false;

  @override
  void initState() {
    super.initState();
    widget.query(widget.id, limit: _querySize, start: 0).then((value) {
      children.addAll(value);
      if (value.length < _querySize) isComplete = true;
      isLoading = false;
      setState(() {});
    });

    // Fetch more data when bottom of page is reached
    widget.controller.addListener(
      () {
        if (widget.controller.position.pixels + 100 >= widget.controller.position.maxScrollExtent) {
          if (!isLoading && !isComplete) {
            isLoading = true;
            widget.query(widget.id, limit: _querySize, start: children.length).then((value) {
              children.addAll(value);
              if (value.length < _querySize) isComplete = true;
              isLoading = false;
              setState(() {});
            });
          }
        }
      },
    );
  }

  Future<void> refresh() async {
    if (!isLoading) {
      isLoading = true;
      widget.query(widget.id, limit: _querySize, start: 0).then((value) {
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
          controller: widget.controller,
          slivers: [
            if (widget.gridMode)
              SliverGrid(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 160,
                  childAspectRatio: 4 / 5,
                ),
                delegate: SliverChildListDelegate(children.map((e) => GridItem(e)).toList()),
              )
            else
              SliverList(delegate: SliverChildListDelegate(children.map((e) => ListItem(e)).toList())),
            const SliverPadding(
              padding: EdgeInsets.only(bottom: 80),
            )
          ],
        ),
      ),
    );
  }
}
