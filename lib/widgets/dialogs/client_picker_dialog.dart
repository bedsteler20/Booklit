// Package imports:

// Project imports:
import 'package:booklit/booklit.dart';

class ClientPicker extends StatelessWidget {
  const ClientPicker({Key? key}) : super(key: key);

  static void open(BuildContext context) =>
      showDialog(context: context, builder: (_) => const ClientPicker());

  @override
  Widget build(BuildContext context) {
    final clients = STORAGE.loadClients();
    context.watch<RepoProvider>();

    List<Widget> items = clients.map((e) {
      return ListTile(
        title: Text(e.title),
        subtitle: Text(e.title2 ?? ""),
        selected: e.clientId == REPOSITORY.data!.clientId,
        onTap: () {
          if (e.clientId != REPOSITORY.data!.clientId) {
            REPOSITORY.connect(e, save: false, setPrimaryClient: true);
            context.read<AudioProvider>().stop();
          }
        },
      );
    }).toList()
      ..addAll([
        ListTile(
          title: const Text("Add Plex Library"),
          leading: const Icon(Icons.add),
          onTap: () {
            var account = Account.fromMap(STORAGE.accounts.get("plex-account"));
            context.read<AudioProvider>().stop();

            showDialog(
              context: context,
              builder: (_) => PlexServerPicker(
                token: account.token,
                clientId: account.clientId,
              ),
            ).then((value) => Navigator.pop(context));
          },
        )
      ]);

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () => Navigator.pop(context)),
        title: const Text("Servers"),
      ),
      body: ListView(children: items),
    );
  }
}
