// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:go_router/go_router.dart';

// Project imports:
import 'package:plexlit/globals.dart';
import 'package:plexlit/helpers/context.dart';
import 'package:plexlit/helpers/media_item_extention.dart';
import 'package:plexlit/model/model.dart';
import '../helper_widgets/flutter_helpers.dart';
import '../helper_widgets/image_widget.dart';

class MediaRowWidget extends StatelessWidget {
  const MediaRowWidget({
    Key? key,
    required this.items,
    required this.onShowMore,
    this.title = "null",
  }) : super(key: key);

  final List<MediaItem> items;
  final String title;
  final void Function() onShowMore;
  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          title: Text(title, style: Theme.of(context).textTheme.headline6),
          dense: true,
          trailing: IconButton(
            icon: Icon(Icons.arrow_forward, color: context.primaryColor),
            onPressed: onShowMore,
          ),
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
                    onPressed: () => item.goTo(context),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Center(
                          child: ImageWidget(
                            url: repository.data!.transcodeImage(
                              item.thumb,
                              height: 150,
                              width: 150,
                            ),
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
