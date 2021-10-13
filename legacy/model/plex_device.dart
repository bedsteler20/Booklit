// To parse this JSON data, do
//
//     final plexDevice = plexDeviceFromMap(jsonString);

import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:plexlit/legacy/model/plex_conection.dart';
part 'hive_intersepters/plex_device.g.dart';

@HiveType(typeId: 1)
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
    this.connections = const [],
  });
  @HiveField(0)
  final String? name;
  @HiveField(1)
  final String? product;
  @HiveField(2)
  final String? productVersion;
  @HiveField(3)
  final String? platform;
  @HiveField(4)
  final String? platformVersion;
  @HiveField(5)
  final String? device;
  @HiveField(6)
  final String? clientIdentifier;
  @HiveField(7)
  final String? createdAt;
  @HiveField(8)
  final String? lastSeenAt;
  @HiveField(9)
  final String? provides;
  @HiveField(10)
  final dynamic ownerId;
  @HiveField(11)
  final dynamic sourceTitle;
  @HiveField(12)
  final String? publicAddress;
  @HiveField(13)
  final String? accessToken;
  @HiveField(14)
  final bool? owned;
  @HiveField(15)
  final bool? home;
  @HiveField(16)
  final bool? synced;
  @HiveField(17)
  final bool? relay;
  @HiveField(18)
  final bool? presence;
  @HiveField(19)
  final bool? httpsRequired;
  @HiveField(20)
  final bool? publicAddressMatches;
  @HiveField(21)
  final bool? dnsRebindingProtection;
  @HiveField(22)
  final bool? natLoopbackSupported;
  @HiveField(23)
  final List<PlexConnection>? connections;

  factory PlexDevice.fromJson(String str) => PlexDevice.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  String? get primaryConnection => connections?[0].uri;

  factory PlexDevice.fromMap(Map<String, dynamic> json) => PlexDevice(
        name: json["name"],
        product: json["product"],
        productVersion: json["productVersion"],
        platform: json["platform"],
        platformVersion: json["platformVersion"],
        device: json["device"],
        clientIdentifier: json["clientIdentifier"],
        createdAt: json["createdAt"],
        lastSeenAt: json["lastSeenAt"],
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
        connections:
            List<PlexConnection>.from(json["connections"].map((x) => PlexConnection.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "name": name,
        "product": product,
        "productVersion": productVersion,
        "platform": platform,
        "platformVersion": platformVersion,
        "device": device,
        "clientIdentifier": clientIdentifier,
        "createdAt": createdAt,
        "lastSeenAt": lastSeenAt,
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
        "connections": connections?.map((e) => e.toMap()).toList(),
      };
}
