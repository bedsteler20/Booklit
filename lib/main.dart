// Dart imports:
import 'dart:io';

// Flutter imports:
import 'package:just_audio_background/just_audio_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

// Package imports:
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:miniplayer/miniplayer.dart';
import 'package:plexlit_api/plexlit_api.dart';
import 'package:provider/provider.dart';

// Project imports:
import 'package:plexlit/controllers/app_controllor.dart';
import 'package:plexlit/core/hive_settings.dart';
import 'package:plexlit/helpers/context.dart';
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

  var client = Storage.loadClients();
  // var client = [PlexApi(
  //   server: (await PlexApi.findServers(
  //     clientId: "6yrtyeh6z0iuo48edcp8ofb9",
  //     token: "owdaU7utu_pYqeM35mYf",
  //   ))[0],
  //   token: "owdaU7utu_pYqeM35mYf",
  //   libraryId: "5",
  //   clientId: "6yrtyeh6z0iuo48edcp8ofb9",
  // )];

  final audioPlayer = await AudioPlayerService().init();

  runApp(MultiProvider(
      providers: [
        Provider(create: (context) => ConnectivityProvider()),
        ListenableProvider<ApiProvider>(create: (context) => ApiProvider(client.lastOrNull)),
        ListenableProvider(create: (context) => MiniplayerController()),
        ListenableProvider(create: (context) => AppController(context)),
        Provider(create: (context) => audioPlayer),
      ],
      child: Builder(
        builder: (context) {
          return const App();
        },
      )));
}
