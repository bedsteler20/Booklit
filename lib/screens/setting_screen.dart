// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:plexlit/repository/repository.dart';
import 'package:provider/provider.dart';

// Project imports:
import 'package:plexlit/globals.dart';
import 'package:plexlit/helpers/context.dart';
import 'package:plexlit/providers/api_provider.dart';
import 'package:plexlit/service/service.dart';
import 'package:plexlit/core/storage.dart';
import 'package:plexlit/widgets/dialogs/player_speed_dialog.dart';
import 'package:plexlit/widgets/widgets.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final player = context.read<AudioPlayerService>();
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
              subtitle: const Text("The library or server to scan"),
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
            if (context.isAndroid)
              ValueListenableBuilder<bool>(
                valueListenable: player.skipSilence,
                builder: (context, val, _) {
                  return SwitchListTile(
                    title: const Text("Skip Silence"),
                    value: val,
                    onChanged: (n) => player.skipSilence.value = n,
                  );
                },
              ),
          ]),
        ],
      ),
    );
  }
}

class ClientPicker extends StatelessWidget {
  const ClientPicker({Key? key}) : super(key: key);

  static void open(BuildContext context) =>
      showDialog(context: context, builder: (_) => const ClientPicker());

  @override
  Widget build(BuildContext context) {
    final clients = storage.loadClients();
    context.watch<RepoProvider>();

    return SimpleDialog(
      title: const Text("Servers"),
      children: clients.map((e) {
        switch (e.runtimeType) {
          case PlexApi:
            e as PlexApi;

            return ListTile(
              title: Text(e.library.title),
              subtitle: Text("${e.server.name!} - ${e.server.ipAddress}"),
              // Selected if type is [PlexApi] & server address match
              selected: e.runtimeType == repository.data!.runtimeType &&
                  e.server.address == (repository.data! as PlexApi).server.address,
              onTap: () => repository.connect(e, save: false),
            );
          default:
            return const SizedBox();
        }
      }).toList()
        ..add(ListTile(
          title: const Text("Add Server"),
          leading: const Icon(Icons.add),
          onTap: () {
            Navigator.pop(context);
            context.to("/login");
          },
        )),
    );
  }
}
