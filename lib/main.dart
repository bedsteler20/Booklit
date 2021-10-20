// Dart imports:
import 'dart:io';

// Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

// Package imports:
import 'package:just_audio_background/just_audio_background.dart';

// Project imports:
import 'package:plexlit/plexlit.dart';
import 'package:plexlit/plexlit.dart';

void main() async {
  if (kIsWeb || Platform.isAndroid) {
    WidgetsFlutterBinding.ensureInitialized();
    await JustAudioBackground.init(
      preloadArtwork: true,
      artDownscaleHeight: 100,
      artDownscaleWidth: 100,
      androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
      androidNotificationChannelName: 'Audio playback',
      androidNotificationOngoing: true,
    );
  }
  await storage.init();

  repository.connect(storage.loadClients().lastOrNull);

  final audioPlayer = await AudioProvider().init();

  runApp(MultiProvider(
      providers: [
        Provider(create: (context) => ConnectivityProvider()),
        ListenableProvider<RepoProvider>(create: (context) => repository),
        ListenableProvider(create: (context) => miniplayerController),
        ListenableProvider(create: (context) => downloads),
        ListenableProvider(create: (context) => audioPlayer),
      ],
      child: Builder(
        builder: (context) {
          return const App();
        },
      )));
}
