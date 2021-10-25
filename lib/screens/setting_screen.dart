// Package imports:
import 'package:flutter_settings_screens/flutter_settings_screens.dart';

// Project imports:
import 'package:plexlit/plexlit.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final player = context.read<AudioProvider>();
    return Scaffold(
      body: Column(
        children: [
          AppBar(
            title: const Text("Settings"),
          ),
          SettingsGroup(title: "General", children: [
            const SizedBox(height: 8),
            ListTile(
              leading: const Icon(Icons.library_add_outlined, size: 32),
              title: const Text("Server"),
              subtitle: const Text("The library or server to scan"),
              onTap: () => ClientPicker.open(context),
            ),
          ]),
          SettingsGroup(
            title: "Player",
            children: [
              ListTile(
                title: const Text("Playback Speed"),
                trailing: const SpeedButton(),
                onTap: () =>
                    showDialog(context: context, builder: (_) => const PlayerSpeedDialog()),
              ),
              SwitchListTile(
                title: const Text("Skip Silence"),
                value: context.select<AudioProvider, bool>((v) => v.skipSilence),
                onChanged: context.read<AudioProvider>().setSkipSilence,
              )
            ],
          ),
          SettingsGroup(
            title: "Accounts",
            children: const [
              AccountSettingsTile("plex-account"),
            ],
          ),
        ],
      ),
    );
  }
}

class AccountSettingsTile extends StatelessWidget {
  const AccountSettingsTile(this.type, {Key? key}) : super(key: key);

  final String type;

  @override
  Widget build(BuildContext context) {
    if (storage.accounts.containsKey(type)) {
      var account = Account.fromMap(storage.accounts.get(type));
      return ListTile(
        title: Text(account.name),
        subtitle: const Text("Plex.tv"),
        onTap: () => showDialog(
            context: context,
            builder: (_) => AlertDialog(
                  title: const Text("Logout of Account?"),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("No"),
                    ),
                    TextButton(
                      child: const Text("Yes"),
                      onPressed: () {
                        storage.accounts.delete(type);
                        if (storage.accounts.isEmpty) context.vRouter.to("/auth");
                        Navigator.pop(context);
                      },
                    )
                  ],
                )),
        leading: Padding(
          padding: const EdgeInsets.all(4.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: Image.network(account.profilePicture.toString()),
          ),
        ),
      );
    } else {
      return SizedBox();
    }

    return Container();
  }
}
