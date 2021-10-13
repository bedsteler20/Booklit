import 'dart:async';
import 'dart:io';

import 'package:flutter_custom_tabs/flutter_custom_tabs.dart' as chrome;
import 'package:url_launcher/url_launcher.dart' as browser;

import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';

import 'http.dart';

class PlexAccount {
  //*------------ Vars ------------*\\
  String? _clientID;
  String? _server;
  String? _token;
  String? _authCode;
  int? _authId;

  int? libraryId;

  //*------------ Constructor ------------*\\
  Future init() async {
    final db = await Hive.openBox("db");

    // token = db.get("token");
    clientID = db.get("client_id") ?? Uuid().v4();
    server = db.get("server");
    libraryId = db.get("library_id");
  }

  //*------------ Metthods ------------*\\

  Future<void> Login(Function(String token) callback, {chrome.CustomTabsOption? tabsOption}) async {
    final session = await http.post(
      "https://plex.tv/api/v2/pins",
      queryParameters: {"strong": true},
    );

    _authCode = session.data["code"];
    _authId = session.data["id"];

    final loginUrl = Uri(
      host: "app.plex.tv",
      path: "/auth/#",
      scheme: "https",
      queryParameters: {
        "code": _authCode,
        "context[device][version]": "1.0",
        "context[device][model]": "Plex OAuth",
        "context[device][product]": "Plex Web", //Exact
        "clientID": clientID, //Note key
      },
    ).toString().replaceAll("/auth/%23", "/auth/#!");

    await _launchUrl(loginUrl, tabsOption: tabsOption);

    Timer.periodic(Duration(seconds: 2), (timer) async {
      if (timer.tick > 25) return;
      String? newToken = await http.get("https://plex.tv/api/v2/pins/$_authId").then((x) => x.data["authToken"]);

      if (newToken == null) return;

      token = newToken;
      Hive.box("db").put("token", newToken);
      callback.call(newToken);
      timer.cancel();
    });
  }

  Future<void> _launchUrl(String url, {chrome.CustomTabsOption? tabsOption}) async {
    // Chrome custom tabs olny work on android. fallback to browser
    if (Platform.isAndroid) {
      await chrome.launch(url, customTabsOption: tabsOption);
    } else {
      await browser.launch(url);
    }
  }

  //*------------ Getters ------------*\\
  String? get clientID => _clientID;
  String? get server => _server;
  String? get library => "/library/sections/$libraryId";
  String? get token => _token;

  //*------------ Setters ------------*\\
  set token(String? x) {
    if (x == null) return;
    _token = x;
    http.options.headers["X-Plex-Token"] = x;
  }

  set clientID(String? x) {
    if (x == null) return;
    _clientID = x;
    http.options.headers["X-Plex-Client-Identifier"] = x;
  }

  set server(String? x) {
    if (x == null) return;
    _server = x;
    http.options.baseUrl = x;
  }
}
