// Dart imports:
import 'dart:async';
import 'dart:io';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart' as chrome;
import 'package:plexlit_api/plexlit_api.dart';
import 'package:url_launcher/url_launcher.dart' as browser;
import 'package:uuid/uuid.dart';

// Project imports:
import 'package:plexlit/modules/plex/plex_server_picker.dart';
import 'package:plexlit/routes.dart';
import 'package:plexlit/storage.dart';

class PlexLoginButton extends StatefulWidget {
  const PlexLoginButton({
    Key? key,
  }) : super(key: key);

  @override
  State<PlexLoginButton> createState() => _PlexLoginButtonState();
}

class _PlexLoginButtonState extends State<PlexLoginButton> {
  Timer? timer;

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future<void> login() async {
    final clientId = const Uuid().v4();
    final api = await PlexOauth.create(clientId: clientId);

    Platform.isAndroid ? await chrome.launch(api.loginUrl) : await browser.launch(api.loginUrl);

    timer = Timer.periodic(const Duration(seconds: 2), (timer) async {
      await api.checkPin().then((token) {
        if (token != null) {
          timer.cancel();
          router.currentState?.pushReplacementNamed("/plex/servers", arguments: {
            "clientId": clientId,
            "token": token,
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(Icons.play_arrow_outlined),
          Text("Login With Plex"),
        ],
      ),
      onPressed: login,
    );
  }
}
