// Dart imports:
import 'dart:io';

// Flutter imports:
import 'package:flutter/foundation.dart';

// Package imports:
import 'package:dio/dio.dart';

// Project imports:
import 'package:booklit/booklit.dart';

Dio _http = Dio(
  BaseOptions(
    headers: {
      "X-Plex-Version": "2.0",
      "X-Plex-Product": "Booklit",
      "X-Plex-Model": "hosted",
      "X-Plex-Device": kIsWeb ? "Web" : Platform.operatingSystem,
      "X-Plex-Device-Name": kIsWeb ? "Web" : Platform.operatingSystem,
      "X-Plex-Sync-Version": "2",
      "X-Plex-Features": "external-media%2Cindirect-media",
      "accept": "application/json",
    },
  ),
);

class PlexOauth {
  PlexOauth({
    this.authCode,
    this.authId,
    required this.clientId,
  });
  String clientId;
  String? authCode;
  int? authId;
  Account? account;

  Future<void> create() async => _http.post(
        "https://plex.tv/api/v2/pins",
        queryParameters: {
          "strong": true,
          "X-Plex-Client-Identifier": clientId,
        },
      ).then((v) {
        authCode = v.data["code"];
        authId = v.data["id"];
      });

  Future<Account?> checkPin() async {
    String? newToken = await _http.get(
      "https://plex.tv/api/v2/pins/$authId",
      queryParameters: {"X-Plex-Client-Identifier": clientId},
    ).then((x) => x.data["authToken"]);

    if (newToken == null) return null;

    final accountData = await _http.get("https://plex.tv/api/v2/user", queryParameters: {
      "X-Plex-Client-Identifier": clientId,
      "X-Plex-Token": newToken,
    });

    account = Account(
      clientId: clientId,
      name: accountData.data["username"],
      profilePicture: Uri.parse(accountData.data["thumb"]),
      token: newToken,
    );

    return account;
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
