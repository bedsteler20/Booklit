// Dart imports:
import 'dart:io';

// Flutter imports:
import 'package:flutter/foundation.dart';

// Package imports:
import 'package:dio/dio.dart';

// Project imports:
import 'package:plexlit/plexlit.dart';

Dio _http = Dio(
  BaseOptions(
    headers: {
      "X-Plex-Version": "2.0",
      "X-Plex-Product": "Plexlit (Flutter)",
      "X-Plex-Model": "hosted",
      "X-Plex-Device":kIsWeb?"Web": Platform.operatingSystem,
      "X-Plex-Device-Name": kIsWeb?"Web":Platform.operatingSystem,
      "X-Plex-Sync-Version": "2",
      "X-Plex-Features": "external-media%2Cindirect-media",
      "accept": "application/json",
    },
  ),
);

class PlexOauth {
  PlexOauth({
    required this.authCode,
    required this.authId,
    required this.clientId,
  });
  String clientId;
  String authCode;
  int authId;
  String? token;

  static Future<PlexOauth> create({required String clientId}) async => _http.post(
        "https://plex.tv/api/v2/pins",
        queryParameters: {
          "strong": true,
          "X-Plex-Client-Identifier": clientId,
        },
      ).then((v) {
        return PlexOauth(
          clientId: clientId,
          authCode: v.data["code"],
          authId: v.data["id"],
        );
      });

  Future<String?> checkPin() async {
    String? newToken = await _http.get(
      "https://plex.tv/api/v2/pins/$authId",
      queryParameters: {"X-Plex-Client-Identifier": clientId},
    ).then((x) => x.data["authToken"]);
    if (newToken == null) return null;
    token = newToken;
    return newToken;
  }

  String get loginUrl => Uri(
        host: "app.plex.tv",
        path: "/auth/#",
        scheme: "https",
        queryParameters: {
          "code": authCode,
          "context[device][version]": "1.0",
          "context[device][model]": "Plex OAuth",
          "context[device][product]": "Plex Web", //Exact
          "clientID": clientId, //Note key
        },
      ).toString().replaceAll("/auth/%23", "/auth/#!");
}

class PlexPasswordAuth {}
