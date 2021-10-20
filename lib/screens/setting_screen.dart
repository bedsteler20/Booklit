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
            title: Text("Settings"),
          ),
          SettingsGroup(title: "Settings", children: [
            const SizedBox(height: 8),
            ListTile(
              leading: const Icon(Icons.library_add_outlined, size: 32),
              title: const Text("Library"),
              subtitle: const Text("The library or server to scan"),
              onTap: () => ClientPicker.open(context),
            ),
            ListTile(
              leading: const Icon(Icons.library_add_outlined, size: 32),
              title: const Text("Logout"),
              subtitle: const Text("Logout of all accounts"),
              onTap: () {
                storage.credentials.clear();
                storage.plexClients.clear();
                storage.progress.clear();
              },
            ),
          ]),
          SettingsGroup(title: "Player", children: [
            ListTile(
              title: const Text("Playback Speed"),
              trailing: const SpeedButton(),
              onTap: () => showDialog(context: context, builder: (_) => const PlayerSpeedDialog()),
            ),
            SwitchListTile(
              title: const Text("Skip Silence"),
              value: context.select<AudioProvider, bool>((v) => v.skipSilence),
              onChanged: context.read<AudioProvider>().setSkipSilence,
            )
          ]),
        ],
      ),
    );
  }
}
