// Project imports:
import 'package:booklit/booklit.dart';

class MediaGroupScreen extends StatefulWidget {
  const MediaGroupScreen(this.route, {Key? key}) : super(key: key);

  final VRouterData route;

  String get id => route.pathParameters["id"]!;

  @override
  State<MediaGroupScreen> createState() => _MediaGroupScreenState();
}

class _MediaGroupScreenState extends State<MediaGroupScreen> {
  final scrollController = ScrollController();

  late final initialItem = MediaItem.fromMap(widget.route.queryParameters);

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => context.vRouter.historyBack(),
          icon: const Icon(Icons.arrow_back_outlined),
        ),
        title: Text(initialItem.title),
      ),
      body: InfiniteScrollView(
        parent: initialItem,
        controller: scrollController,
      ),
    );
  }
}
