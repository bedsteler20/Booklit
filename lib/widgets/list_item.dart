import 'package:plexlit/plexlit.dart';

class ListItem extends StatelessWidget {
  final MediaItem item;

  const ListItem(this.item, {Key? key}) : super(key: key);

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
          onPressed: () => item.goTo(context),
          child: Row(
            children: [
              /*----Image----*/
              Container(
                margin: const EdgeInsets.all(8),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: ImageWidget(
                    url: repository.data!.transcodeImage(
                      item.thumb,
                      height: imageSize.toInt(),
                      width: imageSize.toInt(),
                    ),
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
              )
            ],
          ),
        ),
      ),
    );
  }
}

class LoadingListItem extends StatelessWidget {
  const LoadingListItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: (MediaQuery.of(context).size.width),
      height: 100,
      margin: const EdgeInsets.all(8),
      child: Row(children: [
        /*----Image----*/
        SizedBox(
          width: 100,
          height: 100,
          child: Shimmr(
            borderRadius: BorderRadius.circular(3),
            backgroundColor: Color(Colors.grey.value),
            foregroundColor: Color(Colors.white.value),
          ),
        ),
        /*----Title----*/
        Container(
          width: (MediaQuery.of(context).size.width) * 0.7,
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 16,
                child: Shimmr(borderRadius: BorderRadius.circular(2)),
              ),
              const SizedBox(height: 2),
              SizedBox(
                height: 14,
                child: Shimmr(borderRadius: BorderRadius.circular(2)),
              ),
            ],
          ),
        )
      ]),
    );
  }
}
