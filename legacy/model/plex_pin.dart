class PlexPin {
  String clientIdentifier;
  int id;
  String code;
  String product;
  bool trusted;
  String? authToken;

  PlexPin.fromJson(dynamic json)
      : authToken = json["authToken"],
        clientIdentifier = json["clientIdentifier"],
        code = json["code"],
        product = json["product"],
        trusted=json["trusted"],
        id=json["id"];
}
