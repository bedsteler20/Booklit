// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:plexlit/modules/plex/plex_login_button.dart';
import 'package:plexlit/modules/plex/plex_server_picker.dart';

// Package imports:


// Project imports:

class AuthScreen extends StatelessWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            PlexLoginButton(
            )
          ],
        ),
      ),
    );
  }
}
