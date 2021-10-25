// Dart imports:
import 'dart:async';

// Package imports:
import 'package:dio/dio.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart' as chrome;
import 'package:uuid/uuid.dart';

// Project imports:
import 'package:plexlit/plexlit.dart';

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
    if (storage.accounts.containsKey("plex-account")) {
      var account = Account.fromMap(storage.accounts.get("plex-account"));

      showDialog(
        context: context,
        builder: (_) => PlexServerPicker(
          token: account.token,
          clientId: account.clientId,
        ),
      );
      return;
    }

    final clientId = const Uuid().v4();
    final api = await PlexOauth.create(clientId: clientId);

    context.isAndroid
        ? await chrome.launch(api.loginUrl)
        : context.vRouter.toExternal(api.loginUrl, openNewTab: true);

    timer = Timer.periodic(const Duration(seconds: 2), (timer) async {
      await api.checkPin().then((account) async {
        if (account != null) {
          timer.cancel();

          storage.accounts.put("plex-account", account.toMap());

          showDialog(
            context: context,
            builder: (_) => PlexServerPicker(token: account.token, clientId: account.clientId),
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
