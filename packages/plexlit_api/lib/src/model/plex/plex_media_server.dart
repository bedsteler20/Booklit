// To parse this JSON data, do
//
//     final plexMediaServer = plexMediaServerFromMap(jsonString);

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:plexlit_api/plexlit_api.dart';

class PlexDevice {
  PlexDevice({
    this.name,
    this.product,
    this.productVersion,
    this.platform,
    this.platformVersion,
    this.device,
    this.clientIdentifier,
    this.createdAt,
    this.lastSeenAt,
    this.provides,
    this.ownerId,
    this.sourceTitle,
    this.publicAddress,
    this.accessToken,
    this.owned,
    this.home,
    this.synced,
    this.relay,
    this.presence,
    this.httpsRequired,
    this.publicAddressMatches,
    this.dnsRebindingProtection,
    this.natLoopbackSupported,
    this.connections,
  });

  final String? name;
  final String? product;
  final String? productVersion;
  final String? platform;
  final String? platformVersion;
  final String? device;
  final String? clientIdentifier;
  final DateTime? createdAt;
  final DateTime? lastSeenAt;
  final String? provides;
  final dynamic ownerId;
  final dynamic sourceTitle;
  final String? publicAddress;
  final String? accessToken;
  final bool? owned;
  final bool? home;
  final bool? synced;
  final bool? relay;
  final bool? presence;
  final bool? httpsRequired;
  final bool? publicAddressMatches;
  final bool? dnsRebindingProtection;
  final bool? natLoopbackSupported;
  final List<PlexConnection?>? connections;

  PlexDevice copyWith({
    String? name,
    String? product,
    String? productVersion,
    String? platform,
    String? platformVersion,
    String? device,
    String? clientIdentifier,
    DateTime? createdAt,
    DateTime? lastSeenAt,
    String? provides,
    dynamic ownerId,
    dynamic sourceTitle,
    String? publicAddress,
    String? accessToken,
    bool? owned,
    bool? home,
    bool? synced,
    bool? relay,
    bool? presence,
    bool? httpsRequired,
    bool? publicAddressMatches,
    bool? dnsRebindingProtection,
    bool? natLoopbackSupported,
    List<PlexConnection?>? connections,
  }) =>
      PlexDevice(
        name: name ?? this.name,
        product: product ?? this.product,
        productVersion: productVersion ?? this.productVersion,
        platform: platform ?? this.platform,
        platformVersion: platformVersion ?? this.platformVersion,
        device: device ?? this.device,
        clientIdentifier: clientIdentifier ?? this.clientIdentifier,
        createdAt: createdAt ?? this.createdAt,
        lastSeenAt: lastSeenAt ?? this.lastSeenAt,
        provides: provides ?? this.provides,
        ownerId: ownerId ?? this.ownerId,
        sourceTitle: sourceTitle ?? this.sourceTitle,
        publicAddress: publicAddress ?? this.publicAddress,
        accessToken: accessToken ?? this.accessToken,
        owned: owned ?? this.owned,
        home: home ?? this.home,
        synced: synced ?? this.synced,
        relay: relay ?? this.relay,
        presence: presence ?? this.presence,
        httpsRequired: httpsRequired ?? this.httpsRequired,
        publicAddressMatches: publicAddressMatches ?? this.publicAddressMatches,
        dnsRebindingProtection: dnsRebindingProtection ?? this.dnsRebindingProtection,
        natLoopbackSupported: natLoopbackSupported ?? this.natLoopbackSupported,
        connections: connections ?? this.connections,
      );

  factory PlexDevice.fromJson(String str) => PlexDevice.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory PlexDevice.fromMap(Map json) => PlexDevice(
        name: json["name"],
        product: json["product"],
        productVersion: json["productVersion"],
        platform: json["platform"],
        platformVersion: json["platformVersion"],
        device: json["device"],
        clientIdentifier: json["clientIdentifier"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        lastSeenAt: json["lastSeenAt"] == null ? null : DateTime.parse(json["lastSeenAt"]),
        provides: json["provides"],
        ownerId: json["ownerId"],
        sourceTitle: json["sourceTitle"],
        publicAddress: json["publicAddress"],
        accessToken: json["accessToken"],
        owned: json["owned"],
        home: json["home"],
        synced: json["synced"],
        relay: json["relay"],
        presence: json["presence"],
        httpsRequired: json["httpsRequired"],
        publicAddressMatches: json["publicAddressMatches"],
        dnsRebindingProtection: json["dnsRebindingProtection"],
        natLoopbackSupported: json["natLoopbackSupported"],
        connections: json["connections"] == null
            ? null
            : List<PlexConnection>.from(json["connections"].map((x) => PlexConnection.fromMap(x))),
      );

  Map toMap() => {
        "name": name,
        "product": product,
        "productVersion": productVersion,
        "platform": platform,
        "platformVersion": platformVersion,
        "device": device,
        "clientIdentifier": clientIdentifier,
        "createdAt": createdAt?.toIso8601String(),
        "lastSeenAt": lastSeenAt?.toIso8601String(),
        "provides": provides,
        "ownerId": ownerId,
        "sourceTitle": sourceTitle,
        "publicAddress": publicAddress,
        "accessToken": accessToken,
        "owned": owned,
        "home": home,
        "synced": synced,
        "relay": relay,
        "presence": presence,
        "httpsRequired": httpsRequired,
        "publicAddressMatches": publicAddressMatches,
        "dnsRebindingProtection": dnsRebindingProtection,
        "natLoopbackSupported": natLoopbackSupported,
        "connections":
            connections == null ? null : List<dynamic>.from(connections!.map((x) => x!.toMap())),
      };
  String get address => publicAddressMatches! ? connections![0]!.uri! : connections![1]!.uri!;
  String get ipAddress =>
      publicAddressMatches! ? connections![0]!.address! : connections![1]!.address!;

  Future<List<MediaItem>> library({required String token, required String clientId}) {
    return Dio(BaseOptions(
      baseUrl: address,
      headers: {
        "X-Plex-Client-Identifier": clientId,
        "X-Plex-Token": token,
        "accept": "application/json",
      },
    )).get("/library/sections").then((res) {
      List<MediaItem> i = [];
      for (var x in res.data["MediaContainer"]["Directory"]) {
        if (x["type"] == "artist") i.add(MediaItem(title: x["title"], id: x["key"]));
      }
      return i;
    });
  }
}

class PlexConnection {
  PlexConnection({
    this.protocol,
    this.address,
    this.port,
    this.uri,
    this.local,
    this.relay,
    this.iPv6,
  });

  final String? protocol;
  final String? address;
  final int? port;
  final String? uri;
  final bool? local;
  final bool? relay;
  final bool? iPv6;

  PlexConnection copyWith({
    String? protocol,
    String? address,
    int? port,
    String? uri,
    bool? local,
    bool? relay,
    bool? iPv6,
  }) =>
      PlexConnection(
        protocol: protocol ?? this.protocol,
        address: address ?? this.address,
        port: port ?? this.port,
        uri: uri ?? this.uri,
        local: local ?? this.local,
        relay: relay ?? this.relay,
        iPv6: iPv6 ?? this.iPv6,
      );

  factory PlexConnection.fromJson(String str) => PlexConnection.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory PlexConnection.fromMap(Map json) => PlexConnection(
        protocol: json["protocol"],
        address: json["address"],
        port: json["port"],
        uri: json["uri"],
        local: json["local"],
        relay: json["relay"],
        iPv6: json["IPv6"],
      );

  Map<String, dynamic> toMap() => {
        "protocol": protocol,
        "address": address,
        "port": port,
        "uri": uri,
        "local": local,
        "relay": relay,
        "IPv6": iPv6,
      };
}
