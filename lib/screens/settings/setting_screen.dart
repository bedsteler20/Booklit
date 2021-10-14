// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:plexlit_api/plexlit_api.dart';
import 'package:provider/provider.dart';

// Project imports:
import 'package:plexlit/helpers/context.dart';
import 'package:plexlit/providers/api_provider.dart';
import 'package:plexlit/routes.dart';
import 'package:plexlit/storage.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SettingsGroup(title: "Settings", children: [
      const SizedBox(height: 8),
      ListTile(
        leading: const Icon(Icons.library_add_outlined, size: 32),
        title: const Text("Library"),
        subtitle: const Text("The library or server to scan"),
        onTap: () => ClientPicker.open(context),
      )
    ]);
  }
}

class ClientPicker extends StatelessWidget {
  const ClientPicker({Key? key}) : super(key: key);

  static void open(BuildContext context) =>
      showDialog(context: context, builder: (_) => const ClientPicker());

  @override
  Widget build(BuildContext context) {
    final clients = Storage.loadClients();

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
              selected: e.runtimeType == context.watch<ApiProvider>().server.runtimeType &&
                  e.server.address ==
                      (context.watch<ApiProvider>().server as PlexApi).server.address,
              onTap: () => context.read<ApiProvider>().connect(e, save: false),
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
            router.currentState?.pushNamed("/login");
          },
        )),
    );
  }
}
