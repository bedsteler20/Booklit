import 'package:plexlit/service/plex_conection.dart';
import 'package:plexlit/helpers/media_item_extention.dart';

import 'package:plexlit/legacy/model//plex_device.dart';
import 'package:plexlit/legacy/model//plex_object.dart';
import 'package:plexlit/legacy/model//plex_pin.dart';
import 'package:plexlit/legacy/model//plex_section.dart';

Future<List<PlexSection>> allSections(Plex plex) {
  return plex.dio.get("/library/sections").then((v) {
    return v.data["MediaContainer"]["Directory"]
        .map((x) => PlexSection.fromMap(x as Map<String, dynamic>));
  });
}

Future<PlexPin> createPin(Plex plex) {
  return plex.dio.post("https://plex.tv/api/v2/pins?strong=true").then((r) {
    return PlexPin.fromJson(r.data);
  });
}

Future<PlexPin> checkPin(PlexPin pin, Plex plex) {
  return plex.dio.get("https://plex.tv/api/v2/pins/${pin.id}").then((r) {
    return PlexPin.fromJson(r.data);
  });
}

String oAuthUrl(PlexPin pin) {
  return Uri(
    host: "app.plex.tv",
    path: "/auth/#",
    scheme: "https",
    queryParameters: {
      "code": pin.code,
      "context[device][version]": "1.0",
      "context[device][model]": "Plex OAuth",
      "context[device][product]": "Plex Web", //Exact
      "clientID": pin.clientIdentifier, //Note key
    },
  ).toString().replaceAll("/auth/%23", "/auth/#!");
}

Future<List<PlexDevice>> devices(Plex plex) {
  return plex.dio
      .getUri(Uri(
    scheme: "https",
    path: "/api/v2/resources",
    host: "plex.tv",
    query: "includeHttps=1&includeRelay=1",
  ))
      .then((res) {
    List<PlexDevice> items = [];
    for (var item in res.data) {
      items.add(PlexDevice.fromMap(item));
    }
    return items;
  });
}

Future<List<PlexSection>> sections(Plex plex) {
  return plex.dio.get("/library/sections").then((res) {
    return (res.data["MediaContainer"]["Directory"] as List)
        .map((e) => PlexSection.fromMap(e))
        .toList();
  });
}

Future<List<PlexObject>> allCollections(Plex plex, {int size = 10}) => plex.dio.get(
      "/library/sections/${plex.library!.key}/collections",
      queryParameters: {
        "includeCollections": 1,
        "X-Plex-Container-Size": size,
      },
    ).then((res) => [
          for (var e in res.data["MediaContainer"]["Metadata"])
            PlexObject(
              title: e["title"],
              key: e["key"],
              subtitle: e["parentTitle"],
              thumb: e["thumb"],
            )
        ]);




  // Future<List<PlexObject>> recentlyAdded(PlexConection plex,{int size = 10}) {
  //   return plex.dio.get(
  //     "/library/sections/${Plex.Account.library}/recentlyAdded",
  //     queryParameters: {
  //       "type": 9,
  //       "viewCount>": 1,
  //       "sort": "lastViewedAt:desc",
  //       "excludeFields": "summary",
  //       "X-Plex-Container-Size": size,
  //     },
  //   ).then((res) => [
  //     for (var item in res.data["MediaContainer"]["Metadata"]) {
        
  //     }
  //   ]);
  // }