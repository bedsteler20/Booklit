// Dart imports:
import 'dart:async';
import 'dart:io';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart' as chrome;
import 'package:plexlit/auth/auth.dart';
import 'package:plexlit/globals.dart';
import 'package:url_launcher/url_launcher.dart' as browser;
import 'package:uuid/uuid.dart';

// Project imports:
import 'package:plexlit/helpers/context.dart';
import 'package:vrouter/src/core/extended_context.dart';

import 'plex_auth.dart';

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
    if (storage.credentials.containsKey("plex-clientId")) {
      if (storage.credentials.containsKey("plex-token")) {
        showDialog(
          context: context,
          builder: (_) => PlexServerPicker(
            token: storage.credentials.get("plex-token"),
            clientId: storage.credentials.get("plex-clientId"),
          ),
        );
        return;
      }
    }

    final clientId = const Uuid().v4();
    final api = await PlexOauth.create(clientId: clientId);

    context.isAndroid
        ? await chrome.launch(api.loginUrl)
        : context.vRouter.toExternal(api.loginUrl, openNewTab: true);

    timer = Timer.periodic(const Duration(seconds: 2), (timer) async {
      await api.checkPin().then((token) {
        if (token != null) {
          timer.cancel();
          storage.credentials.put("plex-clientId", clientId);
          storage.credentials.put("plex-token", token);

          showDialog(
            context: context,
            builder: (_) => PlexServerPicker(token: token, clientId: clientId),
          );
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
