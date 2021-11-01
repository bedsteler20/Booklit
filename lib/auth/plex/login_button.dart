// Dart imports:
import 'dart:async';

// Package imports:
import 'package:async_button_builder/async_button_builder.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart' as chrome;

// Project imports:
import 'package:booklit/booklit.dart';

class PlexLoginButton extends StatefulWidget {
  const PlexLoginButton({
    Key? key,
  }) : super(key: key);

  @override
  State<PlexLoginButton> createState() => _PlexLoginButtonState();
}

class _PlexLoginButtonState extends State<PlexLoginButton> {
  Timer? timer;
  PlexOauth api = PlexOauth(clientId: Uuid.v4());

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future<void> login() async {
    if (STORAGE.accounts.containsKey("plex-account")) {
      var account = Account.fromMap(STORAGE.accounts.get("plex-account"));

      showDialog(
        context: context,
        builder: (_) => PlexServerPicker(
          token: account.token,
          clientId: account.clientId,
        ),
      );
    } else {
      await api.create();

      if (context.isAndroid) {
        await chrome.launch(api.loginUrl);
      } else {
        context.vRouter.toExternal(api.loginUrl, openNewTab: true);
      }

      timer = Timer.periodic(const Duration(seconds: 2), pinChecker);
    }
  }

  void pinChecker(Timer timer) async {
    await api.checkPin().then((account) async {
      if (account != null) {
        timer.cancel();

        STORAGE.accounts.put("plex-account", account.toMap());

        showDialog(
          context: context,
          builder: (_) => PlexServerPicker(token: account.token, clientId: account.clientId),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AsyncButtonBuilder(
      child: Icon(Icons.play_arrow_outlined),
      onPressed: login,
      builder: (context, child, callback, buttonState) {
        return ElevatedButton.icon(
          onPressed: callback,
          icon: child,
          label: const Text("Login With Plex"),
        );
      },
    );
  }
}
