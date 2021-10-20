// Project imports:
import 'package:plexlit/plexlit.dart';

class DownloadButton extends StatelessWidget {
  const DownloadButton(this.book, {Key? key}) : super(key: key);
  final Audiobook book;
  @override
  Widget build(BuildContext context) {
    final isDonwnloaded = storage.downloadsIndex.containsKey(book.id);
    return IconButton(
      icon: Icon(isDonwnloaded ? Icons.download_done_rounded : Icons.download_outlined),
      onPressed: () {
        context.find<DownloadsProvider>().download(book);
      },
    );
  }
}
