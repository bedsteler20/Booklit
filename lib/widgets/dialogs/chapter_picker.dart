// Project imports:
import 'package:booklit/booklit.dart';

class ChapterPicker extends StatelessWidget {
  const ChapterPicker({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var chapterId = context.select<AudioProvider, int>((x) => x.chapterIndex);
    var chapters = context.select<AudioProvider, List<Chapter>>((x) => x.current!.chapters);

    List<Widget> items = [];

    for (var i = 0; i < chapters.length; i++) {
      var chapter = chapters[i];
      items.add(ListTile(
        selected: i == chapterId,
        title: Text(chapter.name),
        onTap: () => context.read<AudioProvider>().seek(null, chapterIndex: i),
      ));
    }

    return SimpleDialog(
      title: const Text("Chapters"),
      children: items,
    );
  }
}
