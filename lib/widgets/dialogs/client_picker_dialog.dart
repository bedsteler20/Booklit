import 'package:flutter/material.dart';
import 'package:plexlit/globals.dart';
import 'package:plexlit/providers/api_provider.dart';
import 'package:plexlit/repository/plex_repository.dart';
import 'package:provider/src/provider.dart';
import 'package:vrouter/src/core/extended_context.dart';

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
          case PlexRepository:
            e as PlexRepository;

            return ListTile(
              title: Text(e.library.title),
              subtitle: Text("${e.server.name!} - ${e.server.ipAddress}"),
              // Selected if type is [PlexApi] & server address match
              selected: e.runtimeType == repository.data!.runtimeType &&
                  e.server.address == (repository.data! as PlexRepository).server.address,
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
            context.vRouter.to("/auth");
          },
        )),
    );
  }
}
