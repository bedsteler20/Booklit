// Project imports:
import 'package:plexlit/plexlit.dart';

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
    if (items.isEmpty) return const SizedBox();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          title: Text(title, style: Theme.of(context).textTheme.headline6),
          dense: true,
          //
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            for (var item in items)
              Container(
                margin: const EdgeInsets.all(8),
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
                            url: item.thumb,
                            icon: item.icon,
                            width: 150,
                            height: 150,
                            transcode: true,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.all(8),
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
