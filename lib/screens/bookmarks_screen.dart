import 'package:booklit/plexlit.dart';

class BookmarksScreen extends StatelessWidget {
  const BookmarksScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bookmarks = context.select<AudioProvider, List<Bookmark>>((e) => e.bookmarks);

    var chapterId = context.select<AudioProvider, int>((x) => x.chapterIndex);
    var chapters = context.select<AudioProvider, List<Chapter>>((x) => x.current!.chapters);

    return SizedBox.expand(
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: const TabBar(
            tabs: [
              Tab(text: "Bookmarks"),
              Tab(text: "Chapters"),
            ],
          ),
          body: TabBarView(children: [
            ListView(
              children: bookmarks.map((e) {
                return ListTile(
                  title: Text(
                    "Chapter ${e.chapterNumber} - ${e.position.toString().replaceAll(".000000", "")}",
                  ),
                  subtitle: e.message == null ? null : Text(e.message!),
                  trailing: IconButton(
                    icon: Icon(Icons.play_arrow_outlined),
                    onPressed: () {
                      context.find<AudioProvider>().seek(e.position, chapterIndex: e.chapterNumber);
                      Navigator.pop(context);
                    },
                  ),
                  onLongPress: () => showConfirmDialog(
                    context: context,
                    title: "Remove Bookmark",
                    onConfirm: () => context.find<AudioProvider>().removeBookmark(e),
                  ),
                );
              }).toList(),
            ),
            ListView(
              children: [
                for (var i = 0; i < chapters.length; i++)
                  ListTile(
                    selected: i == chapterId,
                    title: Text(chapters[i].name),
                    onTap: () => context.read<AudioProvider>().seek(null, chapterIndex: i),
                  )
              ],
            )
          ]),
        ),
      ),
    );
  }
}
