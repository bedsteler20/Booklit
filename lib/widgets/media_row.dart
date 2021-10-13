// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:build_context/src/build_context_impl.dart';
import 'package:plexlit_api/plexlit_api.dart';

// Project imports:
import 'package:plexlit/helpers/media_item_extention.dart';
import 'package:plexlit/routes.dart';
import 'flutter_helpers.dart';
import 'image_widget.dart';

class MediaRowWidget extends StatelessWidget {
  const MediaRowWidget({
    Key? key,
    required this.items,
    this.title = "null",
  }) : super(key: key);

  final List<MediaItem> items;
  final String title;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RowContainer(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          children: [
            Text(title, style: Theme.of(context).textTheme.headline6),
          ],
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            for (var item in items)
              Container(
                margin: const EdgeInsets.all(8),
                height: 200,
                width: 160,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: RawMaterialButton(
                    onPressed: () => router.currentState?.pushNamed(
                      item.route,
                      arguments: {"title": item.title, 'id':item.id},
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Center(
                          child: ImageWidget(
                            url: item.thumb,
                            icon: item.icon,
                            width: 150,
                            height: 150,
                            transcode: true,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Expanded(
                          child: Text(
                            item.title,
                            maxLines: 2,
                            textAlign: TextAlign.start,
                            overflow: TextOverflow.ellipsis,
                            style: context.textTheme.bodyText2!.copyWith(fontSize: 18),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ]),
        ),
      ],
    );
  }
}
