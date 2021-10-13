// To parse this JSON data, do
//
//     final plexConnection = plexConnectionFromMap(jsonString);

import 'dart:convert';

import 'package:hive_flutter/adapters.dart';
part 'hive_intersepters/plex_conection.g.dart';
@HiveType(typeId: 6)
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
    @HiveField(0)
    final String? protocol;
    @HiveField(1)
    final String? address;
    @HiveField(2)
    final int? port;
    @HiveField(3)
    final String? uri;
    @HiveField(4)
    final bool? local;
    @HiveField(5)
    final bool? relay;
    @HiveField(6)
    final bool? iPv6;

    factory PlexConnection.fromJson(String str) => PlexConnection.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory PlexConnection.fromMap(Map<String, dynamic> json) => PlexConnection(
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
