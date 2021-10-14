// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:plexlit_api/plexlit_api.dart';

// Project imports:
import 'package:plexlit/helpers/context.dart';
import 'package:plexlit/providers/api_provider.dart';
import 'package:plexlit/widgets/widgets.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({
    Key? key,
  }) : super(key: key);
  @override
  _LibraryScreenState createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  static const _querySize = 50;

  List<MediaItem> children = [];
  bool isLoading = true;
  bool isComplete = false;
  bool gridMode = false;
  final scrollController = ScrollController();

  PlexlitApiClient get client => context.find<ApiProvider>().server;

  @override
  void initState() {
    super.initState();
    client.getAudiobooks(limit: _querySize, start: 0).then((value) {
      children.addAll(value);
      if (value.length < _querySize) isComplete = true;
      isLoading = false;
      setState(() {});
    });

    // Fetch more data when bottom of page is reached
    scrollController.addListener(
      () {
        if (scrollController.position.pixels + 100 >= scrollController.position.maxScrollExtent) {
          if (!isLoading && !isComplete) {
            isLoading = true;
            client.getAudiobooks(limit: _querySize, start: children.length).then((value) {
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
      client.getAudiobooks(limit: _querySize, start: 0).then((value) {
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
            if (context.isSmallTablet)
              SliverGrid(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 160,
                  childAspectRatio: 4 / 5,
                ),
                delegate: SliverChildListDelegate(children.map((e) => GridItem(e)).toList()),
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
