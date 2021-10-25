// Dart imports:
import 'dart:io';

// Flutter imports:
import 'package:flutter/foundation.dart';

// Package imports:
import 'package:just_audio_background/just_audio_background.dart';

// Project imports:
import 'package:plexlit/plexlit.dart';

void main() async {
  if (kIsWeb || Platform.isAndroid) {
    WidgetsFlutterBinding.ensureInitialized();
    await JustAudioBackground.init(
      preloadArtwork: false,
      artDownscaleHeight: 100,
      artDownscaleWidth: 100,
      androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
      androidNotificationChannelName: 'Audio playback',
      androidNotificationOngoing: true,
    );
  }
  await STORAGE.init();

  await REPOSITORY.loadPrimaryClient();

  final audioPlayer = await AudioProvider().init();

  runApp(MultiProvider(
      providers: [
        Provider(create: (context) => ConnectivityProvider()),
        ListenableProvider<RepoProvider>(create: (context) => REPOSITORY),
        ListenableProvider(create: (context) => MINIPLAYER_CONTROLLER),
        ListenableProvider(create: (context) => DOWNLOADS),
        ListenableProvider(create: (context) => audioPlayer),
      ],
      child: Builder(
        builder: (context) {
          return const App();
        },
      )));
}
