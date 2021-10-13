// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:plexlit_api/plexlit_api.dart';

// Project imports:
import 'package:plexlit/controllers/app_controllor.dart';
import 'package:plexlit/helpers/context.dart';
import 'package:plexlit/helpers/media_item_extention.dart';
import 'package:plexlit/routes.dart';
import 'image_widget.dart';
import 'shimmr.dart';

class GridItem extends StatelessWidget {
  const GridItem(this.item, {Key? key}) : super(key: key);

  final MediaItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: RawMaterialButton(
          onPressed: () => router.currentState?.pushNamed(item.route, arguments: {"id":item.id}),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ImageWidget(
                url: item.thumb,
                asspectRatio: 1 / 1,
              ),
              const SizedBox(height: 4),
              Text(
                item.title,
                maxLines: 1,
                textAlign: TextAlign.start,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.caption!.copyWith(fontWeight: FontWeight.bold),
              ),
              Text(
                item.title2 ?? "Null",
                maxLines: 1,
                textAlign: TextAlign.start,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.caption,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class LoadingGridItem extends StatelessWidget {
  const LoadingGridItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 130,
              width: 130,
              child: Shimmr(
                borderRadius: BorderRadius.circular(3.0),
              ),
            ),
            const SizedBox(height: 4),
            ClipRRect(
              borderRadius: BorderRadius.circular(3.0),
              child: Container(
                height: Theme.of(context).textTheme.caption!.fontSize! + 2,
                width: 130,
                color: Colors.grey,
              ),
            ),
            SizedBox(
              height: Theme.of(context).textTheme.caption!.fontSize,
              width: 110,
              child: Shimmr(
                borderRadius: BorderRadius.circular(3.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
