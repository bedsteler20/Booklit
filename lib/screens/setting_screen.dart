// Package imports:
import 'package:flutter_settings_screens/flutter_settings_screens.dart';

// Project imports:
import 'package:booklit/booklit.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final player = context.read<AudioProvider>();
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
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
                ),
                SwitchListTile(
                  title: Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Text(
                      "Auto-Rewind",
                      style: context.bodyText1?.copyWith(fontSize: 16),
                    ),
                  ),
                  subtitle: const Text(
                      "When resuming playback, Booklit will rewind between 0 and 20 seconds depending on how long ago you last listen"),
                  value: context.select<AudioProvider, bool>((v) => v.autoRewindEnabled),
                  onChanged: context.read<AudioProvider>().setAutoRewindEnabled,
                )
              ],
            ),
            SettingsGroup(
              title: "Accounts",
              children: const [
                AccountSettingsTile("plex-account"),
              ],
            ),
            SettingsGroup(
              title: "Other Stuff",
              children: [
                ListTile(
                  title: Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Text(
                      "reddit.com/r/Booklit",
                      style: context.bodyText1?.copyWith(fontSize: 16),
                    ),
                  ),
                  onTap: () => context.vRouter.toExternal("https://reddit.com/r/Booklit"),
                  subtitle: const Text(
                      "Share bug reports, request features, and learn about upcoming features"),
                ),
                ListTile(
                  title: const Text("Licencees"),
                  onTap: () => showLicensePage(context: context),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class AccountSettingsTile extends StatelessWidget {
  const AccountSettingsTile(this.type, {Key? key}) : super(key: key);

  final String type;

  @override
  Widget build(BuildContext context) {
    if (STORAGE.accounts.containsKey(type)) {
      var account = Account.fromMap(STORAGE.accounts.get(type));
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
                        STORAGE.accounts.delete(type);
                        if (STORAGE.accounts.isEmpty) context.vRouter.to("/auth");
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
      return const SizedBox();
    }
  }
}
