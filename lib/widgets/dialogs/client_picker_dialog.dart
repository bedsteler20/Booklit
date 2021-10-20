// Project imports:
import 'package:plexlit/plexlit.dart';

class ClientPicker extends StatelessWidget {
  const ClientPicker({Key? key}) : super(key: key);

  static void open(BuildContext context) =>
      showDialog(context: context, builder: (_) => const ClientPicker());

  @override
  Widget build(BuildContext context) {
    final clients = storage.loadClients();
    context.watch<RepoProvider>();

    return SimpleDialog(
      title: const Text("Librarys"),
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
        ..addAll([
          ListTile(
            title: const Text("Add Plex Library"),
            leading: const Icon(Icons.add),
            onTap: () {
              Navigator.pop(context);
              showDialog(
                context: context,
                builder: (_) => PlexServerPicker(
                  token: storage.credentials.get("plex-token"),
                  clientId: storage.credentials.get("plex-clientId"),
                ),
              );
            },
          )
        ]),
    );
  }
}
