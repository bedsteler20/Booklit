// Project imports:
import 'package:booklit/booklit.dart';

class DownloadingListItem extends StatelessWidget {
  final MediaItem item;
  final double progress;
  final VoidCallback onCancel;
  const DownloadingListItem(
    this.item, {
    required this.progress,
    required this.onCancel,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final imageSize = context.isSmallTablet ? 135.0 : 100.0;

    return Container(
      width: context.width,
      height: imageSize,
      margin: const EdgeInsets.all(8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: RawMaterialButton(
          onPressed: () => null,
          onLongPress: onCancel,
          child: Row(
            children: [
              /*----Image----*/
              Container(
                margin: const EdgeInsets.all(8),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: ImageWidget(
                    url: item.thumb,
                    height: imageSize,
                    width: imageSize,
                  ),
                ),
              ),
              /*----Title----*/
              Container(
                width: (context.width).clamp(0, 300),
                padding: const EdgeInsets.all(8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.bodyText1,
                    ),
                    Text(
                      item.title2 ?? "Null",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.caption,
                    ),
                  ],
                ),
              ),
              Align(
                child: CircularProgressIndicator(value: progress),
                alignment: Alignment.centerRight,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
