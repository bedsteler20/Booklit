// Project imports:
import 'package:booklit/booklit.dart';

// import 'dart:convert';

// import '_api/api.dart';
// import 'package:books_finder/books_finder.dart';
// import '_api/library_items_stream.dart';

// class Scraper {
//   static Future<void> updateAll() async {
//     final items = await LibraryItemsStream.getAll();

//     for (var item in items) {
//       update(item.ratingKey);
//     }
//   }

//   static Future<void> update(int ratingKey) async {
//     final plexItem = await http.get(
//       "/library/metadata/$ratingKey",
//       queryParameters: {
//         "includeChapters": 1,
//         "includeReviews": 1,
//         "includeCollections": 1,
//       },
//     ).then((e) => e.data["MediaContainer"]["Metadata"][0]);

//     final List<String> locked = []; //plexItem["Field"].map((val) => val["name"]) ?? [];
//     final Map<String, dynamic> metadataHeader = {"id": ratingKey, "type": 9};

//     print("Updating:" + plexItem["title"]);

//     final gBook = await queryBooks(
//       plexItem["title"],
//       printType: PrintType.books,
//       orderBy: OrderBy.relevance,
//       reschemeImageLinks: true,
//       maxResults: 1,
//     ).then((value) => value[0].info);

//     if (!locked.contains("summary")) metadataHeader["summary.value"] = gBook.description;
//     if (!locked.contains("originallyAvailbleAt")) metadataHeader["originallyAvailbleAt.value"] = gBook.rawPublishedDate;

//     if (!locked.contains("genre")) {
//       for (var i = 0; i < gBook.categories.length; i++) {
//         metadataHeader["genre[$i].tag.tag"] = gBook.categories[i];
//       }
//     }

//     // Custom Feilds
//     Map customFields = jsonDecode(plexItem["studio"]) ?? {};

//     customFields.addAll({"plexlit.mature": gBook.maturityRating == "MATURE"});

//     metadataHeader["studio.value"] = jsonEncode(customFields);

//     // Update thumb
//     if (plexItem["thumb"] == null && !locked.contains("thumb")) {
//       await http.post(
//         "/library/metadata/$ratingKey/posters",
//         queryParameters: {
//           "url": (gBook.imageLinks["thumbnail"] ?? gBook.imageLinks["medium"]).toString(),
//         },
//       );
//     }

//     await http.put(Plex.Account.library! + "/all", queryParameters: metadataHeader);
//   }
// }

// class CustomPlexFields {
//   final int? ratingsCount;
//   final double? averageRating;
//   final String? language;
//   final bool? mature;
//   final String? summary;

//   CustomPlexFields({this.ratingsCount, this.averageRating, this.language, this.mature, this.summary});

//   String toJson() {
//     final obj = {
//       "ratingsCount": ratingsCount,
//       "averageRating": averageRating,
//       "language": language,
//       "mature": mature,
//       "summary": summary,
//     };

//     obj.removeWhere((key, value) => value == null);

//     return "Plexlit:${jsonEncode(obj)}";
//   }

//   factory CustomPlexFields.summery(String str) {
//     // Suport summerys that arnt made by with plexlit

//     return CustomPlexFields();
//   }
// }
