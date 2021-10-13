class PlexAuthor {
  final String title;
  final String key;
  final int ratingKey;

  PlexAuthor({required this.ratingKey, required this.title, required this.key});

  factory PlexAuthor.fromMap(Map x) => PlexAuthor(
        ratingKey: int.parse(x["ratingKey"]),
        title: x["title"],
        key: x["key"],
      );
}