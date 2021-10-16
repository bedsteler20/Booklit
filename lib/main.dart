// Dart imports:
import 'dart:io';

// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

// Package imports:
import 'package:just_audio_background/just_audio_background.dart';
import 'package:miniplayer/miniplayer.dart';
import 'package:provider/provider.dart';

// Project imports:
import 'package:plexlit/globals.dart';
import 'package:plexlit/helpers/list.dart';
import 'package:plexlit/providers/providers.dart';
import 'package:plexlit/service/service.dart';
import 'package:plexlit/storage.dart';
import 'app.dart';
import 'providers/api_provider.dart';

void main() async {
  if (Platform.isAndroid) {
    await JustAudioBackground.init(
      preloadArtwork: true,
      artDownscaleHeight: 100,
      artDownscaleWidth: 100,
      androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
      androidNotificationChannelName: 'Audio playback',
      androidNotificationOngoing: true,
    );
  }

  await Storage.init();

  repository.connect(Storage.loadClients().lastOrNull);

  final audioPlayer = await AudioPlayerService().init();

  runApp(MultiProvider(
      providers: [
        Provider(create: (context) => ConnectivityProvider()),
        ListenableProvider<Repo>(create: (context) => repository),
        ListenableProvider(create: (context) => MiniplayerController()),
        // ListenableProvider(create: (context) => AppController(context)),
        Provider(create: (context) => audioPlayer),
      ],
      child: Builder(
        builder: (context) {
          return const App();
        },
      )));
}
