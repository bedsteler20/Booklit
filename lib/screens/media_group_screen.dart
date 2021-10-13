// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:plexlit_api/plexlit_api.dart';

// Project imports:
import 'package:plexlit/widgets/widgets.dart';

class MediaGroupScreen extends StatefulWidget {
  const MediaGroupScreen({
    required this.id,
    required this.query,
    this.gridMode = false,
    this.title = "",
    Key? key,
  }) : super(key: key);

  final String id;
  final String title;
  final bool gridMode;
  final Future<List<MediaItem>> Function(String id, {int limit, int start}) query;

  @override
  State<MediaGroupScreen> createState() => _MediaGroupScreenState();
}

class _MediaGroupScreenState extends State<MediaGroupScreen> {
  final scrollController = ScrollController();

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: InfiniteScrollView(id: widget.id, controller: scrollController, query: widget.query),
    );
  }
}
