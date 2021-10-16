// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:plexlit/auth/auth.dart';

// Project imports:

// Package imports:

// Project imports:

class AuthScreen extends StatelessWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            PlexLoginButton(),
          ],
        ),
      ),
    );
  }
}
