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
        return ListTile(
          title: Text(e.title),
          subtitle: Text(e.title2 ?? ""),
          selected: e.clientId == repository.data!.clientId,
          onTap: () => repository.connect(e, save: false, setPrimaryClient: true),
        );
      }).toList()
        ..addAll([
          ListTile(
            title: const Text("Add Plex Library"),
            leading: const Icon(Icons.add),
            onTap: () {
              Navigator.pop(context);

              var account = Account.fromMap(storage.accounts.get("plex-account"));

              showDialog(
                context: context,
                builder: (_) => PlexServerPicker(
                  token: account.token,
                  clientId: account.clientId,
                ),
              );
            },
          )
        ]),
    );
  }
}
