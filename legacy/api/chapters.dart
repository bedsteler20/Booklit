class ChapterFile {
  int index;
  String name;
  String url;
  Duration length;

  ChapterFile({required this.index, required this.name, required this.url, required this.length});

  factory ChapterFile.fromMap(Map e) => ChapterFile(
        index: int.parse(e["index"]),
        name: e["name"],
        url: e["url"],
        length: Duration(milliseconds: e["length"]),
      );
  Map toMap() => {
        "index": index,
        "name": name,
        "url": url,
        "length": length,
      };
}

class EmbededChapter {
  Duration start;
  Duration end;
  int index;
  late Duration length = end - start;
  late String name = "Chapter " + index.toString();

  Map toMap() => {
        "end": end.inMilliseconds,
        "start": start.inMicroseconds,
        "index": index,
        "length": length.inMicroseconds,
        "name": name,
      };

  factory EmbededChapter.fromMap(Map e) => EmbededChapter(
        end: Duration(milliseconds: e["end"]),
        start: Duration(milliseconds: e["start"]),
        index: int.parse(e["index"]),
      );
  EmbededChapter({required this.end, required this.start, required this.index});
}
