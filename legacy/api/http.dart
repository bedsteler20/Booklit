import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:dio_cache_interceptor_hive_store/dio_cache_interceptor_hive_store.dart';

// ignore: non_constant_identifier_names
Dio http = Dio(
  BaseOptions(
    headers: {
      "X-Plex-Version": "2.0",
      "X-Plex-Product": "Plexlit (Flutter)",
      "X-Plex-Model": "hosted",
      "X-Plex-Device": Platform.operatingSystem,
      "X-Plex-Device-Name": Platform.operatingSystem,
      "X-Plex-Sync-Version": "2",
      "X-Plex-Features": "external-media%2Cindirect-media",
      "accept": "application/json",
    },
  ),
)..interceptors.add(DioCacheInterceptor(options: CacheOptions(store: BackupCacheStore(primary: MemCacheStore(), secondary: HiveCacheStore(null)))));
